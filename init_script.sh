
# 判断文件不存在

if [ ! -e /etc/sysconfig/network-scripts/ifcfg-ens33.bak  ] 
then 
    cp /etc/sysconfig/network-scripts/ifcfg-ens33  /etc/sysconfig/network-scripts/ifcfg-ens33.bak
fi