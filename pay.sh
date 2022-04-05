#!/bin/bash
js="./js/pay.js" #支付工作js
cid_file="./log/cid_file.log"
pay_error_log="./log/pay_err.log"
echo "------------------------------------------------------------"

#循环获取/cid/目录下的文件名
while true
do
	ls ./cid/ >$cid_file 
	echo "------------------------------------------------------------"
	echo "文件名获取成功，保存位置:$cid_file"

    #按行获取每个cid文件名
	for i in `cat $cid_file`
	do
		echo "开始支付$i中的文件"
        
        #循环开始支付文件中的cid
		while read line
		do
				mv $js.bak $js  >/dev/null 2>&1
				cp $js $js.bak  >/dev/null 2>&1
				echo "PAYLOAD_CID: $line"
				sed -i 's/AAAA/'$line'/g' $js

                #如果支付成功则将这个payload_cid从文件中删除，如果失败则重定向到error文件 
				if [ `/usr/local/bin/node $js|wc -l` -eq 1 ] ;then
				sed -i '/'$line'/d' ./cid/$i
				else
				echo $line >>$pay_error_log
				fi
				sed -i 's/'$line'/AAAA/g' $js 
		done<./cid/$i

        #支付完毕，则删除此文件
		rm -rf ./cid/$i
		echo "$i文件已支付完毕，文件已删除,开始下个文件"
		echo "------------------------------------------------------------"
	done

	echo "所有文件已支付，等待30秒开始重新获取文件名"
	sleep 30
done
