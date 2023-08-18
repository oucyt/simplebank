#!/bin/sh
echo '打印第2行'
sed -n '2p' ./input.txt 

echo '打印3~6行'
sed -n '3,6p' ./input.txt 

# 注意，会将删除后的内容打印出来，不会改变源文件的内容
echo '删除第9行'
sed '9d' ./input.txt 

echo '删除4~最后'
sed '4,$d' ./input.txt 

echo '在第1行后追加>>>hello<<<'
sed '1a>>>hello<<<' ./input.txt 

echo '在第1行前插入xiaomi'
sed '1ixiaomi' ./input.txt 

echo '将第2~5行替换为abc'
sed '2,5cabc' ./input.txt 

echo '将第4行的like替换为hate'
sed '4s/like/hate/g' ./input.txt 

echo '将第4行的like替换为hate,同时将rest替换为working'
sed '4s/like/hate/g;4s/rest/working/g' ./input.txt 


sed -e '/BOOTPROTO/s/dhcp/static/' \
    -e '$a\IPADDR=192.168.29.200'  \
    -e '$a\NETMASK=255.255.255.0'  \
    -e '$a\GATEWAY=192.168.29.2'   \
    -e '$a\DNS1=114.114.114.114'   \
    -e '$a\DNS2=8.8.8.8'           \
    /etc/sysconfig/network-scripts/ifcfg-ens33
