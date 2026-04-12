#!/bin/bash
apt update -y
apt install -y python3-pip git

git clone https://github.com/YOUR_REPO.git /app
cd /app/backend

pip3 install -r requirements.txt
pip3 install gunicorn psycopg2-binary

python3 manage.py migrate

gunicorn project.wsgi:application --bind 0.0.0.0:8000