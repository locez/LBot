### 群消息处理插件
在本目录下可定义群消息处理插件，如果该文件名为 `xxx.rb`，则定义插件的格式为：

#### 1.文件中必须包含一个与文件名相同的函数，该函数接收以下三个参数，可在该函数中处理你的逻辑
``` ruby
def xxx sender_id, group_id, raw_msg
    # do something
end
```
``` bash
sender_id         # 发送者 qq
group_id          # 群号
raw_msg           # 原始数据，通常只使用 msg = raw_msg['message']，
                  可自行输出查看结构
```

其中，参数名不强制要求，但是尽量按上面的定义，下面的例子则没有遵守该规则
example:
``` ruby
def xxx x,y,z
    sleep 3
    send_group_msg y,"hello, I am Locez"
end
```
在函数中可使用的 API 有
``` bash
at_qq sender_id                             # 拼接消息字符串时，可用此函数 @ 发送者
send_group_msg group_id, msg                # 发送群消息
set_group_kick group_id, user_id            # 踢出群成员
set_group_ban group_id, user_id, minutes    # 禁言，单位分钟
cancel_group_ban group_id, user_id          # 取消禁言
```



