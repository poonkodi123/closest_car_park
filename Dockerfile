FROM ruby:2.6
RUN apt-get update -qq && apt-get install -y \
    build-essential libpq-dev apt-transport-https

# node
RUN curl -sL https://deb.nodesource.com/setup_6.x | bash - \
    && apt-get install -y nodejs

# yarn
RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
    && echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list \
    && apt-get update && apt-get install -y yarn

RUN mkdir /wego
WORKDIR /wego
ADD Gemfile /wego/Gemfile
ADD Gemfile.lock /wego/Gemfile.lock
ADD . /wego
