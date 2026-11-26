#!/bin/bash
set -ex
source .env

apt update
apt install -y apache2 php libapache2-mod-php php-mysql php-xml php-mbstring php-curl php-zip php-gd php-intl mysql-server

cp ../conf/000-default.conf /etc/apache2/sites-available/000-default.conf
a2enmod rewrite
rm -f /var/www/html/index.html

systemctl restart apache2
