FROM ruby:2.5.3

RUN apt-get update && apt-get install -qq -y --no-install-recommends \
  build-essential nodejs libpq-dev imagemagick zlib1g-dev apt-utils \
  libmagickwand-dev libmagickcore-dev vim

ENV INSTALL_PATH /workspace/rails_app/transport

RUN mkdir -p $INSTALL_PATH

WORKDIR $INSTALL_PATH

ENV BUNDLE_PATH /workspace/rails_app/transport/box

ADD Gemfile /workspace/rails_app/transport/Gemfile
ADD Gemfile.lock /workspace/rails_app/transport/Gemfile.lock

#COPY Gemfile ./
#RUN bundle install

COPY . .

# EXPOSE 3000
#
# CMD ["bundle", "exec", "rails", "server", "-b", "0.0.0.0"]
