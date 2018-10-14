
# this plug use a third vendor privatebin-cli, 
# which means that your system should have a nodejs environment if you want to use this plug 

def paste_code sender_id, group_id, raw_msg
    keyword = /int|double|float|main|return|def|if|for|while|end/
    message = raw_msg['message']
    if message.scan(keyword).length >= 3 and message.length > 100
        message.gsub!("&#91;","[").gsub!("&#93;","]")
        code_url = post_code message
        puts code_url
        send_group_msg group_id, code_url 
    end
end

def post_code code
    privatebin = File.dirname(__FILE__) + "/../../vendor/PrivateBin-Cli/privatebin.js"
    code_url = `echo "#{code}" | #{privatebin}`
    code_url.gsub!(/Send.*/,"").gsub!(/Your delete.*/,"").gsub!("\n","")
    code_url 
end

                                 
