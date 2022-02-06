FROM ruby:2.6.3

RUN apt-get update -qq && apt-get install -y nodejs

WORKDIR /src/app
COPY Gemfile* ./
RUN bundle install
COPY . .


COPY entrypoint.sh /entrypoint.sh
RUN chmod +x /entrypoint.sh
ENTRYPOINT ["/entrypoint.sh"]
EXPOSE $APPLICATION_PORT
