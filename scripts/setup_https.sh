#!/bin/bash
set -ex
source .env

if [ ! -f /etc/ssl/certs/wordpress.crt ]; then
    openssl req -x509 -nodes -days 365 -newkey rsa:2048 \
        -keyout /etc/ssl/private/wordpress.key \
        -out /etc/ssl/certs/wordpress.crt \
        -subj "/C=ES/O=$CERT_ORGANIZATION/CN=$SERVER_NAME" \
        -addext "subjectAltName=IP:$SERVER_NAME"
    chmod 600 /etc/ssl/private/wordpress.key
fi

cp ../conf/default-ssl.conf /etc/apache2/sites-available/default-ssl.conf
sed -i "s/PUT_YOUR_SERVER_NAME_HERE/$SERVER_NAME/g" /etc/apache2/sites-available/default-ssl.conf

sed -i "s|#Redirect permanent / https://PUT_YOUR_SERVER_NAME_HERE/|Redirect permanent / https://$SERVER_NAME/|" /etc/apache2/sites-available/000-default.conf

a2enmod ssl
a2ensite default-ssl.conf
apache2ctl configtest
systemctl reload apache2
