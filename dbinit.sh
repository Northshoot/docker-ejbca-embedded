#!/bin/bash

mkdir -p /etc/ejbca/
if [ ! -f /etc/ejbca/dbinit ]; then
        echo "This is the first launch - will init ssl certs, db parameters..."
	echo "  Will use embedded database - mariadb"
	echo "# ------------- Database configuration ------------------------" > $EJBCA_HOME/conf/database.properties
	echo "database.name=mysql" >> $EJBCA_HOME/conf/database.properties
	echo "database.url=jdbc:mysql://127.0.0.1:3306/ejbca?characterEncoding=UTF-8" >> $EJBCA_HOME/conf/database.properties
	echo "database.driver=org.mariadb.jdbc.Driver" >> $EJBCA_HOME/conf/database.properties
	echo "database.username=ejbca" >> $EJBCA_HOME/conf/database.properties
	echo "database.password=ejbca" >> $EJBCA_HOME/conf/database.properties

	# start mariadb
	/usr/bin/mysql_install_db -u mysql
	/usr/bin/mysqld_safe &
	while !(/usr/bin/mysqladmin ping)
	do
		echo "Wating for MariaDB start up"
		sleep 1;
	done

	echo "MariaDB is started ! create database"
	mysql -h localhost -u root -e "create database ejbca;grant all privileges on ejbca.* to 'ejbca'@'localhost' identified by 'ejbca';flush privileges;"

        # create flag file
        touch /etc/ejbca/dbinit;

else
        echo "DB Already initialized, no need to reinit"
	# launch mariadb
	/usr/bin/mysqld_safe &
	while !(/usr/bin/mysqladmin ping)
	do
		echo "Wating for MariaDB start up"
		sleep 1;
	done
	echo "MariaDB is started."
fi

