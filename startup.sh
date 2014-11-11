#!/bin/sh
# *************************************************************************

echo "Just to be sure, stop the listener and database"
service dbora stop

echo "Change hostname in the listener.ora"
dbhost=`uname -n`
sed -i "/(ADDRESS = (PROTOCOL = TCP)(HOST/c\(ADDRESS = (PROTOCOL = TCP)(HOST = ${dbhost})(PORT = 1521))" /oracle/product/12.1/db/network/admin/listener.ora

echo "Start the listener and database"
service dbora start

echo "Done"