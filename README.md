# LBot
---
## prepare
``` bash
git clone -b master https://github.com/locez/LBot.git
cd LBot
gem install websocket-eventmachine-client
gem install json
```

## run coolq
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
## login with browser

## config
``` bash
cp config.rb.example config.rb
```

## run LBot
``` bash
ruby LBot.rb
```
