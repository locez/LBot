require 'net/http'

def paste_code sender_id, group_id, raw_msg
    keyword = /int|double|float|main|return|def|if|for|while/
    message = raw_msg['message']
    if message.scan(keyword).length >= 3 and message.length > 100
        code_url = post_code message
        puts code_url
        content = "代码已经粘贴到: \n" + code_url
        send_group_msg group_id, content
    end
end

def post_code code
    uri = URI("https://paste.ubuntu.com")
    response = Net::HTTP.post_form uri,
        :poster => "LBot",
        :syntax => "text",
        :expiration => "day",
        :content => code
    response['location']
end

 
