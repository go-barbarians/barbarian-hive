#!/bin/sh

if [[ -z $MARIADB_JDBC_VERSION ]];
then
	MARIADB_JDBC_VERSION="mariadb-java-client-2.3.0"
fi

if [[ -z $MARIADB_JDBC_DOWNLOAD_URL ]];
then
	MARIADB_JDBC_DOWNLOAD_URL="https://downloads.mariadb.com/Connectors/java/connector-java-2.3.0/mariadb-java-client-2.3.0.jar"
fi

echo "downloading MariaDB JDBC driver"
python /opt/barbarian/control/download.py -u $MARIADB_JDBC_DOWNLOAD_URL -t /opt/barbarian/hive/lib/${MARIADB_JDBC_VERSION}.jar

