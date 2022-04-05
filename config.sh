#!/bin/bash
#echo "开始下载安装node.js v16.13.0"
#wget https://nodejs.org/download/release/v16.13.0/node-v16.13.0-linux-x64.tar.gz
#tar xf ./node-v16.13.0-linux-x64.tar.gz
#sudo ln -s ./node-v16.13.0-linux-x64.tar.gz/bin/node /usr/local/bin/
#sudo ln -s ./node-v16.13.0-linux-x64.tar.gz/bin/npm /usr/local/bin/
clear
if [ `node -v` == "v16.13.0" ];then
	echo ".........node版本检查正确"
else
	echo "node版本不正确,当前版本为`node -v`,需要版本:v16.13.0"
	exit
fi
if [ `npm -v` == "8.1.0" ];then
        echo ".........npm版本正确"
else
        echo "npm版本不正确,当前版本为`npm -v`,需要版本:8.1.0"
        exit
fi
#echo "安装Mcs-client"
#npm install mcs-client
if [ `npm list |grep mcs-client|wc -l` -eq 1 ];then 
echo -e ".........Mcs-client 安装正确"
else 
echo "Mcs-client 安装错误"
exit
fi
echo -e "------环境检查完毕，开始配置必要参数-------"
echo -e "可选官方RPC_URL\nhttps://rpc-mumbai.matic.today/\nhttps://matic-mumbai.chainstacklabs.com/\nhttps://rpc-mumbai.maticvigil.com/\nhttps://matic-testnet-archive-rpc.bwarelabs.com/\n"
read -ep "请输入rpc_url:" rpc_url
read -ep "请输入MetaMask钱包地址私钥:" privateKey
read -ep "请输入批量上传文件个数(最大支持500,禁止为0):" num
if [ $num -le 0 ] || [ $num -gt 500 ];then
echo "输入有误，请重新运行此脚本"
exit
fi
clear 
echo "----------------------------------------"
echo -e "privateKey = $privateKey"
echo -e "rpc_url = $rpc_url"
echo -e "num = $num"
echo "----------------------------------------"
read -ep "以上信息是否输入无误（y/n）" good
if [ $good = "y" ];then
sed -i "s&    rpcUrl = '.*'.*&    rpcUrl = '${rpc_url}',&" ./node_modules/mcs-client/index.js
sed -i "s&    privateKey = '.*'.*&    privateKey = '${privateKey}',&" ./node_modules/mcs-client/index.js
sed -i "s&num=.*&num=${num}&" ./upload.sh
cp ./js/upload.500.js ./js/upload.js
num1=$((num + 11))
sed -i "$num1,511d" ./js/upload.js
echo "参数配置完毕，开始上传请运行upload.sh，开始支付请运行pay.sh"
else
echo "请重新运行此脚本"
exit
fi
