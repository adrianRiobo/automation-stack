#!/bin/sh

#
# Wait for Mysql is running
#
waitForMysql() {

	while ! mysql -u $WORDPRESS_DB_USER -p$WORDPRESS_DB_PASSWORD --host=$WORDPRESS_DB_HOST --port=$WORDPRESS_DB_PORT $WORDPRESS_DB_DATABASE  -e ";" ;
	do
		echo "Can't connect to" $WORDPRESS_DB_DATABASE ", waiting 15 seconds to try again"
       		sleep 15
	done
}
