#!/bin/bash

service mariadb start

sleep 5

mariadb < ./setup.sql

mysqladmin -u root -p$MYSQL_ROOT_PASS shutdown

mysqld_safe --port=3306 --bind-address=0.0.0.0 --datadir='/var/lib/mysql'
#default data directory for MariaDB installations
#continuous operation 
#restart automatically if error
