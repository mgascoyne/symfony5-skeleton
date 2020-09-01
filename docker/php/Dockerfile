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
      php7.4-common \
      php7.4-xsl \
      php7.4-xml \
      php7.4-cli \
      php7.4-curl \
      php7.4-mysql \
      php7.4-json \
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
      php-xdebug \
      php-apcu \
      php-memcached \
      php-gnupg \
      php-geoip \
      php-dev \
      curl \
      git \
      acl \
      unzip && \
    pecl update-channels && \
    pecl install mongodb && \
    echo "extension=mongodb.so" > /etc/php/7.4/mods-available/mongodb.ini && \
    ln -s /etc/php/7.4/mods-available/mongodb.ini /etc/php/7.4/cli/conf.d/20-mongodb.ini && \
    ln -s /etc/php/7.4/mods-available/mongodb.ini /etc/php/7.4/fpm/conf.d/20-mongodb.ini && \
    curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer && \
    curl -o- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash --login && \
    curl -o /usr/local/bin/phing https://www.phing.info/get/phing-latest.phar && \
    chmod go=+rx /usr/local/bin/phing && \
    bash -c "source ~/.nvm/nvm.sh && nvm install v12.16" && \
    bash -c "source ~/.nvm/nvm.sh && nvm alias default v12.16" && \
    bash -c "source ~/.nvm/nvm.sh && npm install -g yarn" && \
    mkdir -p /run/php

# PHP configuration
ADD php.cli.ini  /etc/php/7.4/cli/
ADD php.fpm.ini  /etc/php/7.4/fpm/
ADD php-fpm.conf /etc/php/7.4/fpm/
ADD www.conf     /etc/php/7.4/fpm/pool.d/

# Xdebug for CLI
RUN if [ "$XDEBUG_ENABLE" = "1" ]; then \
        # Xdebug command
        rm -f /usr/local/bin/xdebug; \
        touch /usr/local/bin/xdebug; \
        echo "export XDEBUG_CONFIG=\"idekey=PHPSTORM\""     >> /usr/local/bin/xdebug; \
        echo "export PHP_IDE_CONFIG=\"$XDEBUG_SERVERNAME\"" >> /usr/local/bin/xdebug; \
        echo "php -d xdebug.autostart=true -d xdebug.remote_enable=1 -d xdebug.remote_host=\`ip route | grep default | awk '{ print $3 }'\` $@" >> /usr/local/bin/xdebug; \
        chmod +x /usr/local/bin/xdebug; \
    fi

# Swiftmailer output
RUN mkdir -p /var/spool/swiftmailer/default

# Volume
VOLUME /app

# Ports
EXPOSE  9001

WORKDIR /app
CMD ["php-fpm7.4", "-F"]
