#!/usr/bin/env ruby
require 'telegram/bot'

puts "Starting bot... with API_TOKEN: #{ENV['API_TOKEN']}"

users = {}

notes_folder = '~/Documents/Projects/MarkdownProjects/ANX'
notes_file = File.expand_path("#{notes_folder}/chat-#{Time.now.strftime('%Y-%m-%d')}.md")

task_folder = '~/Documents/Projects/CProjects/fltktimer'
task_file = File.expand_path("#{task_folder}/tasks")

messages_count = 0

Telegram::Bot::Client.run(ENV['API_TOKEN']) do |bot|
  puts 'Bot started!'

  Signal.trap('INT') do
    bot.stop
  end

  bot.listen do |message|
    id = message.chat.id

    unless users.key?(id)
      chat = bot.api.get_chat(chat_id: id)
      users[id] = "#{chat['result']['first_name']} #{chat['result']['last_name']}"
    end

    text = message.text
    user_message = "> #{users[id]}:\n#{message.text}"
    puts user_message

    if text == '/start'
      response = "#{run("Hello Miko! My name is #{users[id]}, is nice to meet you.")} desu"
      bot.api.send_message(chat_id: id, text: response)
    elsif text.downcase.start_with?('task')
      File.write(task_file, "#{text}\n\n", mode: 'a')
      bot.api.send_message(chat_id: id, text: 'Task added!')
    elsif text
      File.write(notes_file, "#{user_message}\n", mode: 'a')

      if (messages_count % 3).zero?
        pre_responses = ['mmm', 'eto', 'well', "that's", 'emm', 'you see']
        bot.api.send_message(chat_id: id, text: "#{pre_responses.sample}...")
      end
      messages_count += 1
    end
  end
end
