FROM ruby:3.4.7

RUN apt-get update && apt-get install -y git git-extras git-crypt gh
WORKDIR /app

COPY Gemfile Gemfile.lock ./

RUN bundle install

COPY . .

CMD ["ruby", "bot.rb"]
