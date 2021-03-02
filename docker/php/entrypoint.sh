#!/usr/bin/env bash
if [ "$XDEBUG_ENABLE" = "1" ]; then \
  # Xdebug command
  rm -f /usr/local/bin/xdebug; \
  touch /usr/local/bin/xdebug; \
  echo  "export XDEBUG_SESSION=\"PHPSTORM\"" >> /usr/local/bin/xdebug; \
  echo  "export XDEBUG_CONFIG=\"idekey=PHPSTORM\"" >> /usr/local/bin/xdebug; \
  echo  "export PHP_IDE_CONFIG=\"$XDEBUG_SERVERNAME\"" >> /usr/local/bin/xdebug; \
  echo  "php -d xdebug.remote_enable=1 -d xdebug.remote_host=\`ip route | grep default | awk '{ print $3 }'\` -d xdebug.mode=debug -d xdebug.client_host=\`ip route | grep default | awk '{ print $3 }'\` $@\"" >> /usr/local/bin/xdebug; \
  chmod +x /usr/local/bin/xdebug; \
fi

php-fpm7.4 -F
