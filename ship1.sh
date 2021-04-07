#!/bin/bash
##mysql信息
#HOSTNAME="127.0.0.1"
#PORT="3306"
#USERNAME="root"
#DBNAME="ship_soms_v3"
#export MYSQL_PWD=123456
#
##AMS
#AMSPORE=0
#SQLAMSPORT="select com_port from collect_server limit 1;"
#AMSPORE=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME} ${DBNAME} -Bse "${SQLAMSPORT}"`
#
###################################################SQL
#AMSIP=0
#SQLAMSIP="select protocol from collect_server limit 1;"
#AMSIP=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSIP}"`
##-m TCP RTU。。。
#AMSM="tcp"
##-c Number of values to read (1-125, 1 is default)
#AMSC=""
#ADDREE=0
#########################################SOMSKYE
##SQLAMSKEY="select addr,soms_key from collect_point;"
##AMSKEY=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSKEY}"`
#
##AMSA Slave address (1-255 for serial, 0-255 for TCP, 1 is default)
#AMSlLAVEID="select slave_id from collect_server;"
#SLAVEID=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${AMSlLAVEID}"`
#
#
#SQLADDRMAX="select  addr  from collect_point order by id desc  limit 1;"
#ADDRMAX=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME}  -Bse "${SQLADDRMAX}"`

source /opt/shipsoms/config.sh
while true
do
source /opt/shipsoms/config.sh
for i in {0..200}
do
SQLAMSMINI="select group_id,addr,da_precision,soms_key from collect_point where group_id=1 limit ${i},1;"
#AMSGROUP=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSMINI}" | awk {'print $1'}`
AMSGROUP=1
AMSMINI=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSMINI}" | awk {'print $2'}`
AMSKEY=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSMINI}" | awk {'print $4'}`
AMSDA=`mysql -h${HOSTNAME} -P${PORT} -u${USERNAME}  ${DBNAME} -Bse "${SQLAMSMINI}" | awk {'print $3'}`
#AMSDA=`echo $AMSDANEW | awk -F "." {'print $1'}`
i=i++
if [ $AMSKEY ];then
	echo ""
else
	AMSKEY=TN_$AMSGROUP\_$AMSMINI
#	AMSKEY=$AMSKEY1_$AMSMINI
#	echo $AMSKEY
fi
while read line;
do
       VALUE=`/usr/local/src/modpoll/linux_x86-64/modpoll -m ${AMSM} -1 -t4:float -r $AMSMINI -a 2 -p ${AMSPORE} -i ${AMSIP} | grep -w "\["${AMSMINI}"\]" | awk {'print $2'}`
done <<< "abc xyz"
#echo $VALUE
#echo $AMSGROUP
#echo $AMSMINI
#echo $AMSKEY
#echo $AMSDA
VALUES=`echo $VALUE*$AMSDA | bc`
#echo $VALUES
redis-cli -n 2 SET $AMSKEY $VALUES EX 20
done
sleep 4
done
