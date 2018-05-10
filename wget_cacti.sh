#!/bin/bash
time1=`date +%F`
time2=`date +%s`
time3=`date -d '+2 day ago' +%s`
mkdir -p /var/www/html/cacti/${time1}
dir=/var/www/html/cacti/${time1}
for ((num=68;num<88;num++))
do
    wget -O ${num}.png "http://172.16.11.146/cacti/graph_image.php?local_graph_id=${num}&rra_id=0&view_type=tree&graph_start=${time3}&graph_end=${time2}" >/dev/null 2>&1
    mv ./${num}.png ${dir}/
    rm -rf ${dir}/{69,71,80,83,85,86}.png
    rm -rf ${dir}/{74..78}.png
done
rm -rf /var/www/html/cacti/$(date -d '+2 day ago' +%F)
