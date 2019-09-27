FROM ruby:2.3-alpine

RUN apk --update --no-cache add build-base less && mkdir -p /app

RUN apk add --update --no-cache \
    libgcc libstdc++ libx11 glib libxrender libxext libintl libpq postgresql-dev \
    ttf-dejavu ttf-droid ttf-freefont ttf-liberation ttf-ubuntu-font-family postgresql-client

# compiled from: https://github.com/alloylab/Docker-Alpine-wkhtmltopdf
# on alpine static compiled patched qt headless wkhtmltopdf (47.2 MB)
# compilation takes 4 hours on EC2 m1.large in 2016 thats why binary

WORKDIR /app

COPY Gemfile Gemfile.lock ./

COPY ./vendor/ ./vendor/

RUN bundle install

COPY . ./

CMD ["script/docker-entrypoint.sh"]
