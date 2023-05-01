#!/usr/bin/ruby
require 'telegram/bot'
require 'net/http'
require 'json'

token = '6006007757:AAEXULAh5MdHNR85j1ehi9cVjtVB4nc67yg'

HOST = 'localhost:5000'
API_URI = "http://#{HOST}/api/v1/generate"

def run(prompt)
  body = {
    'prompt': prompt,
    'max_new_tokens': 250,
    'do_sample': true,
    'temperature': 1.3,
    'top_p': 0.1,
    'typical_p': 1,
    'repetition_penalty': 1.18,
    'top_k': 40,
    'min_length': 0,
    'no_repeat_ngram_size': 0,
    'num_beams': 1,
    'penalty_alpha': 0,
    'length_penalty': 1,
    'early_stopping': false,
    'seed': -1,
    'add_bos_token': true,
    'truncation_length': 2048,
    'ban_eos_token': false,
    'skip_special_tokens': true,
    'stopping_strings': [".", "?", "!"]
  }

  uri = URI.parse(API_URI)
  http = Net::HTTP.new(uri.host, uri.port)
  request = Net::HTTP::Post.new(uri.request_uri, 'Content-Type' => 'application/json')
  request.body = body.to_json
  response = http.request(request) rescue Exception => e

  if e
    pre_defined = ["My brain is off right now", "I'm in my time off", "I'm not working right now", "Doing my beauty sleep"]
    return pre_defined.sample + ", please come back later zzz..."
  elseif response.code == '200'
    result = JSON.parse(response.body)['results'][0]['text']
    puts "Response: #{result}"
    return result
  end
  return "..."
end

users = {}

Telegram::Bot::Client.run(token) do |bot|
  bot.listen do |message|
    id = message.chat.id

    if !users.key?(id)
      chat = bot.api.get_chat(chat_id: id)
      users[id] = chat['result']['first_name'] + " " + chat['result']['last_name']
    end

    puts "#{users[id]}: #{message.text}"

    case message.text
    when '/start'
      response = run("Hello Miko! My name is #{users[id]}, is nice to meet you.") + " desu"
      bot.api.send_message(chat_id: id, text: response)
    else 
      pre_responses = ["mmm", "eto", "well", "that's", "emm", "you see"]
      bot.api.send_message(chat_id: id, text: "#{pre_responses.sample}...")

      response = run(message.text) + " desu"
      bot.api.send_message(chat_id: id, text: response)
    end
  end
end

