#!/bin/bash
# Exit on error
# set -o errexit -o pipefail
sudo apt update -y
sudo apt dist-upgrade -y
sudo apt -y install apache2
sudo apt -y install software-properties-common
sudo add-apt-repository ppa:ondrej/php -y
# Install important packages 
sudo apt -y install php-curl
sudo apt-get install -y git
sudo apt-get install -y unzip
sudo apt-get install -y zip
sudo apt install php8.1 -y
sudo apt install -y  php8.1-cli php8.1-mbstring  php8.1-mysql php8.1-dom php8.1-xml php8.1-xmlwriter phpunit
sudo apt install -y libapache2-mod-php8.1
sudo a2enmod rewrite
# sudo /etc/init.d/apache2 restart
# Get Composer, and install to /usr/local/bin
if [ ! -f "/usr/local/bin/composer" ]; then
    php -r "copy('https://getcomposer.org/installer', 'composer-setup.php');"
    php composer-setup.php --install-dir=/usr/bin --filename=composer
    php -r "unlink('composer-setup.php');"
else
    /usr/local/bin/composer self-update --stable --no-ansi --no-interaction
fi

curl "https://awscli.amazonaws.com/awscli-exe-linux-x86_64.zip" -o "awscliv2.zip"
unzip awscliv2.zip
sudo ./aws/install
# Set the site configuration parameters
echo "<VirtualHost *:80>" > /etc/apache2/sites-available/testsite.conf
echo "  ServerName www.ghioon.com" >> /etc/apache2/sites-available/testsite.conf
echo "  ServerAlias https://www.ghioon.com" >> /etc/apache2/sites-available/testsite.conf
echo "  DocumentRoot /var/www/html/CiCdLaravelProject/public" >> /etc/apache2/sites-available/testsite.conf
echo "  <Directory /var/www/html/CiCdLaravelProject>" >> /etc/apache2/sites-available/testsite.conf
echo "    Require all granted" >> /etc/apache2/sites-available/testsite.conf
echo "    AllowOverride All" >> /etc/apache2/sites-available/testsite.conf
echo "    Options Indexes Multiviews FollowSymLinks" >> /etc/apache2/sites-available/testsite.conf
echo "  </Directory>" >> /etc/apache2/sites-available/testsite.conf
echo "</VirtualHost>" >> /etc/apache2/sites-available/testsite.conf
# disable default site + enable new site
sudo a2dissite 000-default.conf
sudo a2ensite testsite.conf
# enable rewrite module
sudo a2enmod rewrite

# restart apache
sudo /etc/init.d/apache2 restart

