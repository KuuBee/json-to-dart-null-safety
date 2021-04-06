echo 开始部署
echo 开始连接服务器。。。
ssh aili -t <<EOF
echo 连接成功
cd /home/fontend/json-to-dart-null-safety
echo 删除文件
rm -rf ./.next/
echo 拉取最新代码
git pull origin main
echo 重新安装依赖
npm i
echo 开始打包
npm run build
echo 重启服务
pm2 start ecosystem.config.js 
exit
EOF
echo 部署完成
