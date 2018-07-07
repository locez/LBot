require 'websocket-eventmachine-client'
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

    def send_group_msg group_id, reply_msg
        content = {
            :action => "send_group_msg",
            :params => {
                :group_id => group_id,
                :message => reply_msg
            }
        }.to_json
        @QQ.send content 
    end
    
    def deal_group_msg sender_id, group_id, msg
        #do some thing
        content = at_qq(sender_id) + "hello I am updating!"
        #send_group_msg group_id, content 
    end

    def deal_group_increase sender_id, group_id
        group_config = @group_config[group_id]
        wmsg = group_config[:wmsg] if !group_config.nil? 
        if wmsg.nil?
            wmsg = @default_wmsg
        end
        content = at_qq(sender_id) + wmsg 
        send_group_msg group_id, content 
    end
            
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
                        deal_group_msg sender_id, group_id, msg
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

    def start
        EM.run do
            ws = WebSocket::EventMachine::Client.connect :uri => @ws_uri + '/event/'
            @QQ = WebSocket::EventMachine::Client.connect :uri => @ws_uri + '/api/'

            ws.onmessage do |raw_msg, type|
                puts raw_msg
                deal_raw_msg raw_msg
            end
        end
    end
end

bot = LBot.new
bot.start

