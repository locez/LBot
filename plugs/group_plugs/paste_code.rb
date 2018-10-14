
# this plug use a third vendor privatebin-cli, 
# which means that your system should have a nodejs environment if you want to use this plug 

def paste_code sender_id, group_id, raw_msg
    keyword = /int|double|float|main|return|def|if|for|while|end/
    message = raw_msg['message']
    if message.scan(keyword).length >= 3 and message.length > 100
        message.gsub!("&#91;","[").gsub!("&#93;","]").gsub!("&amp;","&")
        code_url = post_code message
        puts code_url
        send_group_msg group_id, code_url 
    end
end

def post_code code
    privatebin = File.dirname(__FILE__) + "/../../vendor/PrivateBin-Cli/privatebin.js"
    file_name = "/tmp/privatebin" + `date '+%H:%M:%s'`
    File.open(file_name,"w+") do |f|
        f.puts code
    end 
    code_url = `#{privatebin} #{file_name}`
    code_url.gsub!(/Send.*/,"").gsub!(/Your delete.*/,"").gsub!("\n","")
    File.delete(file_name)
    code_url 
end

                                 
