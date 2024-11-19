#! /bin/bash
/usr/local/mysql5.7/bin/mysqld --defaults-file=/etc/my.cnf --initialize --user=mysql --basedir=/usr/local/mysql5.7 --datadir=/usr/local/mysql5.7/data
if [ $? -ne 0 ]
then
    echo "mysql init failed"
    exit 1
fi
/etc/init.d/mysqld start
if [ $? -ne 0 ]
then
    echo "mysql start failed"
    exit 2
fi
pwd=$(cat /var/log/mysqld/mysqld.log | grep "A temporary password is generated for root@localhost: " | awk -F" " '{print $NF}')
/usr/local/mysql5.7/bin/mysqladmin -uroot -p"${pwd}" password "XYTxiao1366+"
if [ $? -ne 0 ]
then
    echo "change password failed"
    exit 3
fi
/usr/local/mysql5.7/bin/mysql -uroot -p"XYTxiao1366+" -e "create database ruoyidb;"
if [ $? -ne 0 ]
then
    echo "create ruoyidb failed"
    exit 5
fi
/usr/local/mysql5.7/bin/mysql -uroot -p"XYTxiao1366+" -e "grant all  on ruoyidb.* to 'ruoyi'@'%' identified by 'XYTxiao1366+';"
if [ $? -ne 0 ]
then
    echo "create user failed"
    exit 4
fi
/usr/local/mysql5.7/bin/mysql -uruoyi -pXYTxiao1366+ -h192.168.50.128 ruoyidb < /tmp/ry_20231130.sql
/usr/local/mysql5.7/bin/mysql -uruoyi -pXYTxiao1366+ -h192.168.50.128 ruoyidb < /tmp/quartz.sql
echo  "init mysql finish"
exit 0
