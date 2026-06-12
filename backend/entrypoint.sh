#!/bin/sh

DB_WAIT_HOST="${DB_HOST:-db}"
DB_WAIT_PORT="${DB_PORT:-5432}"

echo "Waiting for postgres at $DB_WAIT_HOST:$DB_WAIT_PORT ..."

while ! nc -z "$DB_WAIT_HOST" "$DB_WAIT_PORT"; do
  sleep 1
done

echo "PostgreSQL started"

python manage.py migrate
python manage.py collectstatic --noinput

exec "$@"
