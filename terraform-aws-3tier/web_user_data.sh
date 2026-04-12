#!/bin/bash
apt update -y
apt install -y nginx nodejs npm git

git clone https://github.com/YOUR_REPO.git /app
cd /app/frontend

npm install
npm run build

rm -rf /var/www/html/*
cp -r dist/* /var/www/html/

systemctl restart nginx
systemctl enable nginx