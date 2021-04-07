#!/bin/bash
#mysql信息
HOSTNAME="127.0.0.1"
PORT="3306"
USERNAME="root"
DBNAME="ship_soms_v3"
export MYSQL_PWD=123456

#AMS
AMSPORE=0
SQLAMSPORT="select com_port from collect_server limit 1;"
AMSPORE=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} ${DBNAME} -Bse "${SQLAMSPORT}"`

##################################################SQL
AMSIP=0
SQLAMSIP="select protocol from collect_server limit 1;"
AMSIP=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSIP}"`
#-m TCP RTU。。。
AMSM="tcp"
#-c Number of values to read (1-125, 1 is default)
AMSC=""
ADDREE=0
########################################SOMSKYE
#SQLAMSKEY="select addr,soms_key from collect_point;"
#AMSKEY=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSKEY}"`

#AMSA Slave address (1-255 for serial, 0-255 for TCP, 1 is default)
AMSlLAVEID="select slave_id from collect_server;"
SLAVEID=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${AMSlLAVEID}"`


SQLADDRMAX="select  addr  from collect_point order by id desc  limit 1;"
ADDRMAX=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME}  -Bse "${SQLADDRMAX}"`
