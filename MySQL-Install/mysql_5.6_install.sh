#!/bin/bash
# mysql install script, the home directory is /usr/local/mysql-VERSION and the soft link is /usr/local/mysql
yum install libaio
/usr/bin/yum install awk wget -y
config=`/bin/pwd`
mysqlProcessNum=`/bin/ps aux | /bin/grep mysql | /usr/bin/wc -l | /bin/awk '{ print $1 }'`;
if [ $mysqlProcessNum -gt 3 ]; then
    echo "已经安装MySQL"
    exit
fi

# download mysql package
# mysqlDownloadURL=ftp://222.26.224.236/pub/mysql/mysql-5.6.25-linux-glibc2.5-x86_64.tar.gz;
# cd /tmp;
# /bin/rm -rf mysql*.tar.gz
# /usr/bin/wget $mysqlDownloadURL;
# packageName=`/bin/ls | /bin/grep mysql*.tar.gz`;
# unpakcage mysql
/bin/tar zxvf mysql-5.6.25-linux-glibc2.5-x86_64.tar.gz -C /usr/local
mysqlAllNameDir=`/bin/ls -l /usr/local | grep mysql | /bin/awk '{ print $9 }'`
/bin/ln -s $mysqlAllNameDir /usr/local/mysql
userNum=`/bin/cat /etc/passwd | /bin/grep mysql | /bin/awk -F ':' '{ print $1 }' | /usr/bin/wc -l`
if [ $userNum -lt 1 ];then
    /usr/sbin/groupadd mysql
    /usr/sbin/useradd -d /usr/local/mysql -s /sbin/nologin -g mysql mysql
    echo "成功添加"
fi
#/bin/mv /etc/my.cnf /etc/my.cnf.bak
/usr/local/mysql/scripts/mysql_install_db --datadir=/usr/local/mysql/data --user=mysql --basedir=/usr/local/mysql
/bin/chown -R root.mysql /usr/local/mysql
/bin/chown -R mysql.mysql /usr/local/mysql/data/
#我的配置文件放到root目录下面了
/bin/cp $config/my.cnf /etc/　　　　

/usr/local/mysql/bin/mysqld_safe &
#/bin/chown -R mysql.mysql /usr/local/mysql/data/#/bin/cp $config/my.cnf /etc/
#cp /usr/local/mysql/support-files/mysql.server /etc/init.d/mysqld
#chmod 755 /etc/init.d/mysqld