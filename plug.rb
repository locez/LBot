# 群消息处理
# sender_id         发送者 qq
# group_id          群号
# raw_msg           原始数据，通常只使用 msg = raw_msg['message']，
#                   可自行输出查看结构
# send_group_msg    发送群消息API,处理完后调用该函数发送消息
#

group_plugs = []
Dir[ File.dirname(__FILE__) + "/plugs/group_plugs/*.rb" ].each do |plug|
    require plug
    plug.sub!(/.+\/plugs\/group_plugs\/?/,"")
    if plug.end_with?(".rb")
        group_plugs << plug.sub(".rb","")
    end
end

define_method :deal_group_msg do |sender_id, group_id, raw_msg|
    group_plugs.each do |group_plug|
        eval "Thread.new{ #{group_plug}(sender_id,group_id,raw_msg) }"
    end
end
