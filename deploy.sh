echo 开始打包
npm run build
echo 打包完成
echo 开始部署
echo 开始连接服务器。。。
ssh aili -t <<EOF
echo 连接成功
cd /home/fontend/json-to-dart-null-safety
echo 删除文件
rm -rf ./.next/
exit
EOF
echo 删除成功
echo 开始上传文件
# 我这里用了scp上传文件 你可以根据你的需求修改
scp -r /Users/kuubee/Desktop/self_porject/fontend/dart-to-json-null-safety/.next aili:/home/fontend/json-to-dart-null-safety
echo 部署完成
