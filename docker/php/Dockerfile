FROM ubuntu:20.04

LABEL maintainer="Marcel Gascoyne <marcel@gascoyne.de>"
LABEL description="PHP container for Symfony 5"

ARG XDEBUG_ENABLE=1
ARG XDEBUG_SERVERNAME="symfony.local"

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get install -y software-properties-common && \
    add-apt-repository ppa:ondrej/php && \
    apt-get -y update && \
    apt-get install -y \
      apt-transport-https \
      python3-pip \
      mysql-client \
      php8.0-common \
      php8.0-xsl \
      php8.0-xml \
      php8.0-cli \
      php8.0-curl \
      php8.0-mysql \
      php8.0-gd \
      php8.0-fpm \
      php8.0-mbstring \
      php8.0-gettext \
      php8.0-imagick \
      php8.0-opcache \
      php8.0-phpdbg \
      php8.0-intl \
      php8.0-zip \
      php8.0-bcmath \
      php8.0-soap \
      php8.0-xdebug \
      php8.0-apcu \
      php8.0-memcached \
      php8.0-redis \
      php8.0-mongodb \
      curl \
      git \
      acl \
      unzip && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.37.2/install.sh | bash --login && \
    curl -o /usr/local/bin/phing https://www.phing.info/get/phing-latest.phar && \
    chmod go=+rx /usr/local/bin/phing && \
    bash -c "source ~/.nvm/nvm.sh && nvm install v14.16.0" && \
    bash -c "source ~/.nvm/nvm.sh && nvm alias default v14.16.0" && \
    bash -c "source ~/.nvm/nvm.sh && npm install -g yarn" && \
    mkdir -p /run/php

# PHP configuration
ADD php.cli.ini  /etc/php/8.0/cli/php.ini
ADD php.fpm.ini  /etc/php/8.0/fpm/php.ini
ADD php-fpm.conf /etc/php/8.0/fpm/php-fpm.conf
ADD www.conf     /etc/php/8.0/fpm/pool.d/www.conf

# Xdebug for CLI
RUN if [ "$XDEBUG_ENABLE" = "1" ]; then \
        # Xdebug command
        rm -f /usr/local/bin/xdebug; \
        touch /usr/local/bin/xdebug; \
        echo -e "export XDEBUG_SESSION=\"PHPSTORM\"\n" >> /usr/local/bin/xdebug; \
        echo -e "export XDEBUG_CONFIG=\"idekey=PHPSTORM\"\n" >> /usr/local/bin/xdebug; \
        echo -e "export PHP_IDE_CONFIG=\"$XDEBUG_SERVERNAME\"\n" >> /usr/local/bin/xdebug; \
        echo -e "php -d xdebug.remote_enable=1 -d xdebug.remote_host=`ip route | grep default | awk '{ print $3 }'` -d xdebug.mode=debug -d xdebug.client_host=`ip route | grep default | awk '{ print $3 }'` $@" >> /usr/local/bin/xdebug; \
        chmod +x /usr/local/bin/xdebug; \
    fi

# Swiftmailer output
RUN mkdir -p /var/spool/swiftmailer/default

# Volume
VOLUME /app

# Ports
EXPOSE  9001

WORKDIR /app
CMD ["php-fpm8.0", "-F"]
