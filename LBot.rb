require 'websocket-eventmachine-client'
require 'webrick'
require 'json'
class LBot
    def initialize
        get_config 
    end

    def get_config
        config_text = File.readlines("config.rb").join
        config = eval(config_text)
        @default_wmsg = config[:welcome_message]
        @ws_uri = config[:ws_uri]
        @group_config = config[:group_config]
   end

    def at_qq qq
        "[CQ:at,qq=#{qq}] "
    end
    # 发送私聊消息
    def send_private_msg receiver_id, msg
        content = {
            :action => "send_private_msg",
            :params => {
                :user_id => receiver_id,
                :message => msg 
            }
        }.to_json
        @QQ.send content 
    end

    # 发送群消息
    def send_group_msg group_id, msg
        content = {
            :action => "send_group_msg",
            :params => {
                :group_id => group_id,
                :message => msg
            }
        }.to_json
        @QQ.send content 
    end
    
    # 撤回消息，仅 pro 版本支持
    def delete_msg msg_id
        content = {
            :action => "delete_msg",
            :params => {
                :message_id => msg_id 
            }
        }.to_json
        @QQ.send content 
    end

    # 踢出群成员
    def set_group_kick group_id, user_id 
        content = {
            :action => "set_group_kick",
            :params => {
                :group_id => group_id,
                :user_id => user_id,
                :reject_add_request => false
            }
        }.to_json
        @QQ.send content 
    end

    # 禁言群成员，单位分钟
    def set_group_ban group_id, user_id, minutes
        ban_time = 60 * minutes 
        content = {
            :action => "set_group_ban",
            :params => {
                :group_id => group_id,
                :user_id => user_id,
                :duration => ban_time
            }
        }.to_json
        @QQ.send content 
    end

    # 取消禁言
    def cancel_group_ban group_id, user_id
        set_group_ban group_id, user_id, 0
    end

    # 群消息处理
    def deal_group_msg sender_id, group_id, raw_msg
        #do some thing
        content = at_qq(sender_id) + "hello I am LBot!"
        #send_group_msg group_id, content 
    end

    # 群成员增加
    def deal_group_increase sender_id, group_id
        group_config = @group_config[group_id]
        wmsg = group_config[:wmsg] if !group_config.nil? 
        if wmsg.nil?
            wmsg = @default_wmsg
        end
        content = at_qq(sender_id) + wmsg 
        send_group_msg group_id, content 
    end
    
    # 获取群成员列表
    def get_group_member_list group_id
        content = {
            :action => "get_group_member_list",
            :params => {
                :group_id => group_id
            }
        }.to_json
        @QQ.send content
    end

    def get_qq_from_card group_id, card, &blk
        get_group_member_list group_id
        @QQ.onmessage do |raw_msg, type|
            msg = JSON.parse raw_msg
            if msg['data'] != nil && msg['data'][0] != nil && card != ""
                member_list = msg['data']
                qq = nil
                member_list.each do |member|
                    if member['card'].match card
                        qq = member['user_id']
                        break
                    end
                end
                yield qq if block_given? && qq != nil
            end 
        end
    end

    # 解析事件
    def deal_raw_msg raw_msg
        raw_msg = JSON.parse raw_msg
        post_type = raw_msg['post_type']
        case post_type
            when 'message'
                msg = raw_msg['message']
                sender_id = raw_msg['user_id']
                case raw_msg['message_type']
                    when 'private'
                    when 'group'
                        group_id = raw_msg['group_id']
                        deal_group_msg sender_id, group_id, raw_msg
                    when 'discuss'
                end

            when 'notice'
                case raw_msg['notice_type']
                    when 'group_upload'
                    when 'group_admin'
                    when 'group_decrease'
                    when 'group_increase'
                        sender_id = raw_msg['user_id']
                        group_id = raw_msg['group_id']
                        deal_group_increase sender_id, group_id 
                end

            when 'request'
        end
    end

    class Servlet < WEBrick::HTTPServlet::AbstractServlet
        def do_POST(req,res)
            content = JSON.parse(req.body)
            name = content['name']
            info = content['info']
            @@bot.get_qq_from_card 198889102, name do |qq|
                @@bot.send_group_msg 198889102, @@bot.at_qq(qq)  + info
            end
        end
    end

    def start
        Thread.new{
            server = WEBrick::HTTPServer.new :Port => 1234
            server.mount "/", Servlet
            server.start
        }
        EM.run do
            @event = WebSocket::EventMachine::Client.connect :uri => @ws_uri + '/event/'
            @QQ = WebSocket::EventMachine::Client.connect :uri => @ws_uri + '/api/'

            @event.onmessage do |raw_msg, type|
                puts raw_msg
                deal_raw_msg raw_msg
            end
        end
    end
end

@@bot = LBot.new
@@bot.start

