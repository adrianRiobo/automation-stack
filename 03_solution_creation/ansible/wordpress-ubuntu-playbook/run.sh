#!/bin/bash

#Import helpers
. /root/scripts/mysql-functions.sh  --source-only

#Configure wordpress
sed -i.bak s/database_name_here/$WORDPRESS_DB_DATABASE/g /var/www/html/wp-config.php
sed -i.bak s/username_here/$WORDPRESS_DB_USER/g /var/www/html/wp-config.php
sed -i.bak s/password_here/$WORDPRESS_DB_PASSWORD/g /var/www/html/wp-config.php
sed -i.bak s/localhost/$WORDPRESS_DB_HOST:$WORDPRESS_DB_PORT/g /var/www/html/wp-config.php

#Wait for Mysql
echo 'Trying to connecto to Mysql'
waitForMysql

#Start apache
service apache2 start

while [ 1 ]; do sleep 1; done

#exec "$@"
