#!/bin/sh
set -e

echo "Waiting for postgres..."
until nc -z -v -w30 "$POSTGRES_HOST" "$POSTGRES_PORT" 2>/dev/null; do
  sleep 1
done
echo "Postgres is up."

python manage.py migrate --noinput
python manage.py collectstatic --noinput --clear

if [ "$DJANGO_SUPERUSER_USERNAME" ] && [ "$DJANGO_SUPERUSER_PASSWORD" ]; then
  python manage.py createsuperuser --noinput || true
fi

exec daphne -b 0.0.0.0 -p 8000 config.asgi:application
