#!/bin/bash
set -euo pipefail
exec > >(tee /var/log/web-userdata.log) 2>&1

echo "=== Web Tier Bootstrap: $(date) ==="

# ─── System updates & dependencies ───────────────────────────────────────────
dnf update -y
dnf install -y nginx git curl

# ─── Install Node.js 20 ───────────────────────────────────────────────────────
curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
dnf install -y nodejs

# ─── Clone repository ─────────────────────────────────────────────────────────
REPO_URL="${github_repo}"
APP_DIR="/opt/chat-app"

git clone "$REPO_URL" "$APP_DIR" || {
  echo "ERROR: Failed to clone repo. Check github_repo_url variable."
  exit 1
}

# ─── Build React frontend ─────────────────────────────────────────────────────
cd "$APP_DIR/frontend"

# Point the frontend at the external ALB (API proxy handled by Nginx)
cat > .env.production <<EOF
VITE_API_BASE_URL=/api
EOF

npm ci
npm run build

# Copy build output to Nginx web root
mkdir -p /usr/share/nginx/html
cp -r dist/* /usr/share/nginx/html/

# ─── Nginx configuration ──────────────────────────────────────────────────────
# Serves the React SPA and proxies /api/* → internal ALB
cat > /etc/nginx/conf.d/chat-app.conf <<'NGINX'
server {
    listen 80;
    server_name _;

    root /usr/share/nginx/html;
    index index.html;

    # React SPA – return index.html for all non-asset paths
    location / {
        try_files $uri $uri/ /index.html;
    }

    # Proxy API requests → Internal ALB (Django)
    location /api/ {
        proxy_pass         http://${app_alb_dns}:8000;
        proxy_set_header   Host              $host;
        proxy_set_header   X-Real-IP         $remote_addr;
        proxy_set_header   X-Forwarded-For   $proxy_add_x_forwarded_for;
        proxy_set_header   X-Forwarded-Proto $scheme;
        proxy_read_timeout 60s;
    }

    # Health check endpoint for the external ALB
    location /health {
        access_log off;
        return 200 "healthy\n";
        add_header Content-Type text/plain;
    }
}
NGINX

# Remove default nginx config
rm -f /etc/nginx/conf.d/default.conf

# ─── Start Nginx ──────────────────────────────────────────────────────────────
systemctl enable nginx
systemctl start nginx

echo "=== Web Tier Bootstrap complete: $(date) ==="
