#!/bin/bash

curl -O https://raw.githubusercontent.com/wp-cli/builds/gh-pages/phar/wp-cli.phar
#curl to download the wp-cli (WordPress Command Line Interface)
#phar (PHP Archive) file from github

chmod +x wp-cli.phar

mv wp-cli.phar /usr/local/bin/wp
#move file so its accessible to everyone (wp)

cd /var/www/wordpress

chmod -R 755 /var/www/wordpress/

chown -R www-data:www-data /var/www/wordpress
#change owner of WordPress dir and content to www-data user and group :


ping_mariadb() {
    nc -z mariadb 3306   #-zv used to scan for listening daemons; port 3306; check connection
    return $? #return exit status of ping
}

start=$(date +%s) #current time in seconds
end=$((start + 20)) #20 seconds after start time, (()) are used for arithmetic expansion in the shell

#loop until MariaDB is up or timeout
while [ $(date +%s) -lt $end ]; do #less than
    ping_mariadb
    if [ $? -eq 0 ]; then #ping successful; equal to
        echo "[MARIADB UP AND RUNNING]"
        break 
    else  
        echo "[WAITING FOR MARIADB TO START]"
        sleep 1
    fi #close if
done

if [ $(date +%s) -ge $end ]; then #greater or equal
    echo "[MARIADB NOT RESPONDING]"
fi

check_files() {
    wp core is-installed --allow-root > /dev/null
    return $?
}

if ! check_files; then
    echo "[WP INSTALLATION STARTED]"
    find /var/www/wordpress/ -mindepth 1 -delete
    wp core download --allow-root
    wp core config --dbhost=mariadb:3306 --dbname="$MYSQL_DB" --dbuser="$MYSQL_USER" --dbpass="$MYSQL_PASSWORD" --allow-root
    wp core install --url="$DOMAIN_NAME" --title="$WP_TITLE" --admin_user="$WP_ADMIN_U" --admin_password="$WP_ADMIN_P" --admin_email="$WP_ADMIN_E" --allow-root
    wp user create "$WP_U_NAME" "$WP_U_EMAIL" --user_pass="$WP_U_PASS" --role="$WP_U_ROLE" --allow-root
else
    echo "[WordPress files already exist. Skipping installation]"
fi

sed -i '36 s@/run/php/php7.4-fpm.sock@9000@' /etc/php/7.4/fpm/pool.d/www.conf
#stream editor, change unix socket to port 9000 for network communication

mkdir -p /run/php
#pid, active process

/usr/sbin/php-fpm7.4 -F
#starts the PHP-FPM service in the -Foreground to keep the container running

