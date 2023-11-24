#!/bin/bash
# Project directory on server for your project.
WEB_DIR="/var/www/html/CiCdLaravelProject"
# Your server user. Used to fix permission issue & install our project dependcies
WEB_USER="ubuntu"
# Change directory to project.
cd $WEB_DIR

# change user owner to ubuntu & fix storage permission issues.
sudo chown -R ubuntu:ubuntu .
sudo chown -R www-data storage
sudo chmod -R u+x .
sudo chmod g+w -R storage

# install composer dependcies
sudo -u $WEB_USER composer install --no-dev --no-progress --prefer-dist
# restart apache
sudo /etc/init.d/apache2 restart
sudo apt-get -y update

# enable rewrite module
sudo a2enmod rewrite

# restart apache
sudo /etc/init.d/apache2 restart
# Domain and SSL Configuration
sudo apt install -y certbot python3-certbot-apache
sudo pip install certbot-dns-google
# obtain ssl certificate
certbot certonly --non-interactive --agree-tos --email awolabdulbaasit143@gmail.com   --dns-google --installer apache -d www.ghioon.com 
service apache2 restart
echo "0 0 * * * certbot renew" >> /etc/crontab

# load .env file from AWS Systems Manager
./devops/scripts/generate-env.sh

# generate app key & run migrations
sudo -u $WEB_USER php artisan key:generate
sudo -u $WEB_USER php artisan migrate --force --no-interaction