#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/app-userdata.log) 2>&1

echo "=== App Tier Bootstrap: $(date) ==="

# ─── System updates & dependencies ───────────────────────────────────────────
dnf update -y
dnf install -y git python3 python3-pip python3-devel gcc postgresql-devel

# ─── Clone repository ─────────────────────────────────────────────────────────
REPO_URL="${github_repo}"
APP_DIR="/opt/chat-app"

git clone "$REPO_URL" "$APP_DIR" || {
  echo "ERROR: Failed to clone repo."
  exit 1
}

# ─── Python virtual environment ───────────────────────────────────────────────
cd "$APP_DIR/backend"
python3 -m venv venv
source venv/bin/activate

pip install --upgrade pip
pip install -r requirements.txt
pip install gunicorn psycopg2-binary  # Add PostgreSQL driver

# ─── Environment variables ────────────────────────────────────────────────────
# In production, prefer AWS Secrets Manager or SSM Parameter Store
cat > "$APP_DIR/backend/.env" <<EOF
DJANGO_SECRET_KEY=${django_secret_key}
REGISTRATION_SECRET=${registration_secret}
DJANGO_DEBUG=False
DJANGO_ALLOWED_HOSTS=${web_alb_dns},localhost,127.0.0.1

# PostgreSQL / Aurora connection
DB_ENGINE=django.db.backends.postgresql
DB_HOST=${db_host}
DB_PORT=5432
DB_NAME=${db_name}
DB_USER=${db_user}
DB_PASSWORD=${db_password}
EOF

# ─── Update Django settings for PostgreSQL ────────────────────────────────────
# This patches settings.py to use env-based DB config.
# If your settings.py already reads from env, this block can be removed.
python3 - <<'PYEOF'
import os, re

settings_path = "/opt/chat-app/backend/chat_project/settings.py"
with open(settings_path, "r") as f:
    content = f.read()

db_block = """
import os as _os
DATABASES = {
    'default': {
        'ENGINE':   _os.environ.get('DB_ENGINE', 'django.db.backends.postgresql'),
        'NAME':     _os.environ.get('DB_NAME', 'chatapp'),
        'USER':     _os.environ.get('DB_USER', 'chatadmin'),
        'PASSWORD': _os.environ.get('DB_PASSWORD', ''),
        'HOST':     _os.environ.get('DB_HOST', 'localhost'),
        'PORT':     _os.environ.get('DB_PORT', '5432'),
    }
}
"""

# Replace the existing DATABASES dict
content = re.sub(
    r"DATABASES\s*=\s*\{.*?\}(\s*\})+",
    db_block,
    content,
    flags=re.DOTALL,
)

# Add ALLOWED_HOSTS from env if not already dynamic
allowed_hosts_line = "ALLOWED_HOSTS = _os.environ.get('DJANGO_ALLOWED_HOSTS', 'localhost').split(',')\n"
content = re.sub(r"ALLOWED_HOSTS\s*=\s*\[.*?\]", allowed_hosts_line, content, flags=re.DOTALL)

with open(settings_path, "w") as f:
    f.write(content)
print("settings.py patched for Aurora PostgreSQL.")
PYEOF

# ─── Django migrations & static files ────────────────────────────────────────
export $(grep -v '^#' "$APP_DIR/backend/.env" | xargs)

python manage.py migrate --no-input
python manage.py collectstatic --no-input

# ─── Gunicorn systemd service ─────────────────────────────────────────────────
cat > /etc/systemd/system/gunicorn.service <<EOF
[Unit]
Description=Gunicorn daemon for Django Chat App
After=network.target

[Service]
User=root
Group=root
WorkingDirectory=$APP_DIR/backend
EnvironmentFile=$APP_DIR/backend/.env
ExecStart=$APP_DIR/backend/venv/bin/gunicorn \\
    --workers 4 \\
    --bind 0.0.0.0:8000 \\
    --timeout 120 \\
    --access-logfile /var/log/gunicorn-access.log \\
    --error-logfile /var/log/gunicorn-error.log \\
    chat_project.wsgi:application
Restart=on-failure
RestartSec=5s

[Install]
WantedBy=multi-user.target
EOF

systemctl daemon-reload
systemctl enable gunicorn
systemctl start gunicorn

# ─── Health check endpoint ────────────────────────────────────────────────────
# Add a simple /api/health/ view to your urls.py if not already present.
# Example: path('api/health/', lambda r: HttpResponse('ok'))

echo "=== App Tier Bootstrap complete: $(date) ==="
