#!/bin/sh
# *************************************************************************

echo "Change hostname in the listener.ora"
dbhost=`uname -n`
sed -i "/(ADDRESS = (PROTOCOL = TCP)(HOST/c\      (ADDRESS = (PROTOCOL = TCP)(HOST = ${dbhost} )(PORT = 1521))" /oracle/product/12.1/db/network/admin/listener.ora

echo "Start the listener and database"
service dbora start

echo "just to be sure, start the listener again"
su oracle -c "export ORAENV_ASK=NO;export ORACLE_SID=orcl;source oraenv;/oracle/product/12.1/db/bin/lsnrctl start"

echo "Done"

echo "Show all ora processes, should see listener and ora db processes"

ps -ef | grep -i ora