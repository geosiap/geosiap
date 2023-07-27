FROM ruby:3.0.6

EXPOSE 3000
WORKDIR /app

RUN apt-get update -qq && apt-get install -y libpq-dev nodejs build-essential locales
RUN gem install bundler -v 1.17.3
RUN mkdir -p /app
ENV LANG C.UTF-8
COPY . /app/
RUN bundle _1.17.3_ install
