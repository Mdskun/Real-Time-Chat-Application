#!/bin/bash
apt update -y
apt install -y python3-pip git

# Clone your repo
git clone https://github.com/YOUR_REPO.git /app
cd /app/backend

pip3 install -r requirements.txt

python3 manage.py migrate

pip3 install gunicorn

gunicorn project.wsgi:application --bind 0.0.0.0:8000