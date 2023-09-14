#!/usr/bin/ruby
require "telegram/bot"

token = "6006007757:AAEXULAh5MdHNR85j1ehi9cVjtVB4nc67yg"

users = {}
filename = "chat#{(rand * 100).floor()}.txt"
messages_count = 0

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    id = message.chat.id

    if !users.key?(id)
      chat = bot.api.get_chat(chat_id: id)
      users[id] = chat["result"]["first_name"] + " " + chat["result"]["last_name"]
    end

    user_message = "> #{users[id]}:\n#{message.text}"
    puts user_message

    if message.text == "/start"
      response = run("Hello Miko! My name is #{users[id]}, is nice to meet you.") + " desu"
      bot.api.send_message(chat_id: id, text: response)
    elsif message.text
      File.write(filename, user_message + "\n", mode: "a")

      if messages_count % 3 == 0
        pre_responses = ["mmm", "eto", "well", "that's", "emm", "you see"]
        bot.api.send_message(chat_id: id, text: "#{pre_responses.sample}...")
      end
      messages_count += 1
    end
  end
end
