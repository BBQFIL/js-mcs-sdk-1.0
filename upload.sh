#!/bin/bash
log="file_name.log" #上传文件名日志
num=4
biaoji="./log/peg.log" #替换标记名
js="./js/upload.js" #工作js

while true
do
    time1=`date +%s`
    file=`echo $RANDOM` #获取随机数，用作payload_cid日志文件名
    mv $js.bak $js      #恢复备份工作js（以免需要修改js中的标记）
    cp $js $js.bak      #复制工作js（以免需要修改js中的标记）
    
    #清理历史上传文件
    for i in `cat $log`;do rm -rf ./file/$i >/dev/null 2>&1;done 

    #清理历史上传文件名日志
    rm -rf $log >/dev/null 2>&1

    #生成新的上传文件，并将文件名保存到文件名日志中
    for ((i=1;i<=$num;i++))
    do
	    time=`date +%s`
	    n=`expr $time + $i`
	    dd if=/dev/urandom of=./file/$n bs=5000K count=1 >/dev/null 2>&1
	    echo $n >>$log
    done
    echo "$num个上传文件已生成......"
    #按行获取标记点、文件名，并替换工作js中的标记点
    for ((i=1;i<=$num;i++))
    do
    	file=`sed -n ''$i'p' $log`
    	BJ=`sed -n ''$i'p' $biaoji`
	    sed -i 's/'$BJ'/'$file'/g' $js	
    done
    echo "开始上传......"
    #上传
    /usr/local/bin/node $js  |tee ./log/$file
    
    #输出上传信息，并保存为文件
    grep payload_cid ./log/$file|awk -F"'" '{print $2}' |tee ./cid/$file
    
    	time2=`date +%s`
	seconds=$(($time2 - $time1))
        hour=$(( $seconds/3600 ))
        min=$(( ($seconds-${hour}*3600)/60 ))
        sec=$(( $seconds-${hour}*3600-${min}*60 ))
        HMS=`echo ${hour}.${min}.${sec}`
 
    #过滤payload_cid，并保存为文件（用户后期支付使用）
    echo "`date "+%m-%d %H:%M:%S"` 完成$num个任务上传  | 耗时：$HMS   | cid文件位置：./cid/$file  |" 
done
