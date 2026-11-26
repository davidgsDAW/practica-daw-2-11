#!/bin/bash
set -ex
source .env

wget -q https://wordpress.org/latest.tar.gz -O /tmp/latest.tar.gz
tar -xzf /tmp/latest.tar.gz -C /tmp
mkdir -p /var/www/html/wordpress
cp -a /tmp/wordpress/. /var/www/html/wordpress/
rm -rf /tmp/latest.tar.gz /tmp/wordpress

mysql -u root <<< "CREATE DATABASE IF NOT EXISTS $WORDPRESS_DB_NAME CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;"
mysql -u root <<< "CREATE USER IF NOT EXISTS '$WORDPRESS_DB_USER'@'$IP_CLIENTE_MYSQL' IDENTIFIED BY '$WORDPRESS_DB_PASSWORD';"
mysql -u root <<< "GRANT ALL PRIVILEGES ON $WORDPRESS_DB_NAME.* TO '$WORDPRESS_DB_USER'@'$IP_CLIENTE_MYSQL';"
mysql -u root <<< "FLUSH PRIVILEGES;"

cp /var/www/html/wordpress/wp-config-sample.php /var/www/html/wordpress/wp-config.php
sed -i "s/database_name_here/$WORDPRESS_DB_NAME/" /var/www/html/wordpress/wp-config.php
sed -i "s/username_here/$WORDPRESS_DB_USER/" /var/www/html/wordpress/wp-config.php
sed -i "s/password_here/$WORDPRESS_DB_PASSWORD/" /var/www/html/wordpress/wp-config.php
sed -i "s/localhost/$WORDPRESS_DB_HOST/" /var/www/html/wordpress/wp-config.php

sed -i "/DB_COLLATE/a define('WP_SITEURL', 'https://$SERVER_NAME/wordpress');" /var/www/html/wordpress/wp-config.php
sed -i "/WP_SITEURL/a define('WP_HOME', 'https://$SERVER_NAME');" /var/www/html/wordpress/wp-config.php

sed -i "/AUTH_KEY/d" /var/www/html/wordpress/wp-config.php
sed -i "/LOGGED_IN_KEY/d" /var/www/html/wordpress/wp-config.php
sed -i "/NONCE_KEY/d" /var/www/html/wordpress/wp-config.php
sed -i "/AUTH_SALT/d" /var/www/html/wordpress/wp-config.php
sed -i "/LOGGED_IN_SALT/d" /var/www/html/wordpress/wp-config.php
sed -i "/NONCE_SALT/d" /var/www/html/wordpress/wp-config.php

SECURITY_KEYS=$(curl -s https://api.wordpress.org/secret-key/1.1/salt/)
SECURITY_KEYS=$(echo "$SECURITY_KEYS" | tr '\n' ' ' | tr / _)
sed -i "/@-/a $SECURITY_KEYS" /var/www/html/wordpress/wp-config.php

cp /var/www/html/wordpress/index.php /var/www/html/index.php
sed -i "s#wp-blog-header.php#wordpress/wp-blog-header.php#" /var/www/html/index.php

cp ../htaccess/.htaccess /var/www/html/.htaccess
cp ../htaccess/wp-admin.htaccess /var/www/html/wordpress/wp-admin/.htaccess
sed -i "s/IP_ADMIN_HERE/$IP_ADMIN/g" /var/www/html/.htaccess
sed -i "s/IP_ADMIN_HERE/$IP_ADMIN/g" /var/www/html/wordpress/wp-admin/.htaccess

chown -R www-data:www-data /var/www/html
find /var/www/html -type d -exec chmod 755 {} \;
find /var/www/html -type f -exec chmod 644 {} \;
chmod 640 /var/www/html/wordpress/wp-config.php

systemctl restart apache2
