# Yachtboerse 24
#
# Dockerfile for PHP image
#
# Copyright (C) 2021 Marcel Gascoyne
# All rights reserved

FROM ubuntu:20.04

LABEL maintainer="Marcel Gascoyne <marcel@gascoyne.de>"
LABEL description="PHP container for Yachtboerse 24"

ENV XDEBUG_ENABLE=1
ENV XDEBUG_SERVERNAME="yachtboerse24.local"

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get -y update && \
    apt-get install -y \
      iproute2 \
      apt-transport-https \
      python3-pip \
      mysql-client \
      php7.4-common \
      php7.4-xsl \
      php7.4-xml \
      php7.4-cli \
      php7.4-curl \
      php7.4-mysql \
      php7.4-gd \
      php7.4-fpm \
      php7.4-mbstring \
      php7.4-gettext \
      php7.4-imagick \
      php7.4-opcache \
      php7.4-phpdbg \
      php7.4-intl \
      php7.4-zip \
      php7.4-bcmath \
      php7.4-soap \
      php7.4-xdebug \
      php7.4-apcu \
      php7.4-memcached \
      php7.4-redis \
      php7.4-mongodb \
      curl \
      git \
      acl \
      unzip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash --login && \
    bash -c "source ~/.nvm/nvm.sh && nvm install v14.16.0" && \
    bash -c "source ~/.nvm/nvm.sh && nvm alias default v14.16.0" && \
    bash -c "source ~/.nvm/nvm.sh && npm install -g yarn" && \
    mkdir -p /run/php

# Phing
ADD phing-3.0.0-RC1.phar /usr/local/bin/phing
RUN chmod go=+rx /usr/local/bin/phing

# PHP configuration
ADD php.cli.ini  /etc/php/7.4/cli/php.ini
ADD php.fpm.ini  /etc/php/7.4/fpm/php.ini
ADD php-fpm.conf /etc/php/7.4/fpm/php-fpm.conf
ADD www.conf     /etc/php/7.4/fpm/pool.d/www.conf

# Entrypoint script
ADD entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod ugo=+rx /usr/local/bin/entrypoint.sh

# Swiftmailer output
RUN mkdir -p /var/spool/swiftmailer/default

# Volume
VOLUME /app

# Ports
EXPOSE  9001

WORKDIR /app

ENTRYPOINT ["/usr/bin/bash", "-c", "/usr/local/bin/entrypoint.sh"]
