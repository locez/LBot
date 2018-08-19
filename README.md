# LBot
---

本项目基于 `cool q` 以及 [coolq-http-api](https://github.com/richardchien/coolq-http-api)，二次封装，使得可以利用 ruby 编写 qq 机器人

## 获取源码
``` bash
git clone -b master https://github.com/locez/LBot.git
cd LBot
gem install websocket-eventmachine-client
gem install json
```

## 运行 coolq
---
在此处，你可以选择直接运行 酷q 以及 http-api 插件，请参照自行对应的文档，此处采用 docker 运行，请注意不要**直接复制粘贴运行**，先修改好相应的参数再执行。其中 9000 端口为 vnc 登录端口，6700 为 websocket 端口
``` bash
docker run -d -it  --name coolq \
             -v $(pwd)/coolq:/home/user/coolq \
             -p 9000:9000 \
             -p 6700:6700 \
             -e COOLQ_ACCOUNT=QQ \
             -e CQHTTP_SERVE_DATA_FILES=no \
             -e CQHTTP_USE_HTTP=false \
             -e CQHTTP_USE_WS=true \
             -e VNC_PASSWD="yourpasswd" \
             richardchien/cqhttp:latest
```
## 在浏览器登录
---
若你是在本地部署，则在浏览器中输入

``` bash
http://localhost:9000
```
然后输入你的 VNC 密码，QQ，QQ 密码进行登录

## 配置
---
复制 example 进行配置
``` bash
cp config.rb.example config.rb
```

## 运行 LBot
``` bash
ruby LBot.rb
```

# 编写插件
---
该项目可以编写插件，有关插件的内容请参阅 `plugs` 文件夹下的内容

