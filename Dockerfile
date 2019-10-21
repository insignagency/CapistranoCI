FROM ruby:2.6.3-stretch

ARG NODE_VERSION="12.13.0"
ARG CAPISTRANO_VERSION="3.6.1"
ARG NVM_VERSION="v0.35.0"
ENV NVM_DIR="/root/.nvm"

RUN gem install capistrano -v ${CAPISTRANO_VERSION} \
    && curl -o- https://raw.githubusercontent.com/creationix/nvm/${NVM_VERSION}/install.sh | bash \
    && . "$NVM_DIR/nvm.sh" \
    && nvm install ${NODE_VERSION} \
    && npm install -g gulp-cli

ENV PATH      $NVM_DIR/versions/node/v$NODE_VERSION/bin:$PATH
