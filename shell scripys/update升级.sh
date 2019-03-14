#!/bin/bash
################################################
#for update V11.9
#version:v1
################################################
v119(){
mkdir /u01/HHT30/bak/20190314-v11.8
#停止应用
sh /u01/HHT30/stop.sh
sh /u01/int_dis/stop.sh
sh /u01/eos-tdop/shutdown.sh
sh /u01/int_rms/stop.sh
ps -ef |grep java |wc -l
#备份配置文件
\cp /u01/HHT30/config/parameter.properties /u01/int_dis/config/config.properties /u01/HHT30/bak/20190314-v11.8
#更新程序包
cd /u01/HHT30
mv sss_new_dtx5-11.8.jar /u01/HHT30/bak/20190314-v11.8
wget http://10.108.15.108/V11.9/PKG/HHT30/sss_new_dtx5-11.9.jar
cd /u01/int_dis/lib/
wget http://10.108.15.108/V11.9/PKG/int_dis/fastjson-1.2.29.jar
cd /u01/int_dis/
wget http://10.108.15.108/V11.9/PKG/int_dis/sss-new-int_dis-11.9.jar
mv sss-new-int_dis-11.8.jar /u01/HHT30/bak/20190314-v11.8
cd /u01/int_rms/
mv  sss-new-int_rms-V11.8.jar /u01/HHT30/bak/20190314-v11.8
wget http://10.108.15.108/V11.9/PKG/int_rms/sss-new-int_rms-V11.9.jar
#修改配置文件
sed -i '$a\##新增给AWSM传635'  /u01/HHT30/config/parameter.properties
sed -i '$a\awsm_callHospital_url=https://tdop-gw-dcn.sf-express.com/eos-awsm-core-ope/awsmExceptionReport/callHospital'  /u01/HHT30/config/parameter.properties
sed -i '$a\##629查询接口,配置本地中转场服务器地址，或者屏蔽配置(默认屏蔽)' /u01/int_dis/config/config.properties
sed -i '$a\##agentInfo_webserivce_push_url=http://10.202.34.12:9089/webService/queryAgentInfo?wsdl' /u01/int_dis/config/config.properties
cat <<eof
*********************************************
app升级完成，请前往执行sql，然后启动应用并例检
*********************************************
eof
}
check(){
if [ -f /u01/HHT30/bak/20190314-v11.8/parameter.properties ];
then 
echo 'HHT30配置文件已备份'
else 
echo 'HHT30配置文件未备份'
fi
if [ -f /u01/HHT30/bak/20190314-v11.8/config.properties ];
then 
echo 'int_dis配置文件已备份'
else 
echo 'int_dis配置文件未备份'
fi
if 
[ -e /u01/HHT30/sss_new_dtx5-11.9.jar ] && [ -e /u01/int_dis/sss-new-int_dis-11.9.jar ] && [ -e /u01/int_dis/lib/fastjson-1.2.29.jar ] && [ -e /u01/int_rms/sss-new-int_rms-V11.9.jar ];
then
echo '应用程序包已更新完成'
else 
echo '应用程序包未全部更新，请检查'
fi
}
menu(){
cat <<EOF
|Please Enter Your Choice:[1-2|
(1) 进行v11.9升级
(2) 检查
EOF
read -p "Please enter your Choice[1-2]: " input
case "$input" in
1)
v119
;; 
2)
check
;;
*)
cat <<eof
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
please input right choice [1-2]!
!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!
eof
esac
}
menu