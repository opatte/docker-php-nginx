#!/bin/bash

# Increase the memory_limit
if [ ! -z "$PHP_MEM_LIMIT" ]; then
 sed -i "s/memory_limit = 128M/memory_limit = ${PHP_MEM_LIMIT}M/g" /usr/local/etc/php/conf.d/docker-vars.ini
fi

# Increase the post_max_size
if [ ! -z "$PHP_POST_MAX_SIZE" ]; then
 sed -i "s/post_max_size = 100M/post_max_size = ${PHP_POST_MAX_SIZE}M/g" /usr/local/etc/php/conf.d/docker-vars.ini
fi

# Increase the upload_max_filesize
if [ ! -z "$PHP_UPLOAD_MAX_FILESIZE" ]; then
 sed -i "s/upload_max_filesize = 100M/upload_max_filesize= ${PHP_UPLOAD_MAX_FILESIZE}M/g" /usr/local/etc/php/conf.d/docker-vars.ini
fi

# Enable debug mode
if [ ! -z "$DEBUG" ]; then
  apk --update add binutils
  docker-php-ext-enable xdebug
  echo "xdebug.idekey=${XDEBUG_IDEKEY}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.default_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.remote_enable=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.remote_autostart=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.remote_connect_back=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.cli_color=1" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.var_display_max_depth=10" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.profiler_enable=0" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.remote_handler=dbgp" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.remote_port=9020" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
  echo "xdebug.remote_host=${XDEBUG_REMOTE_HOST}" >> /usr/local/etc/php/conf.d/docker-php-ext-xdebug.ini
fi

# Replace the vhost nginx (PROD) by the vhost nginx (LOCAL)
if [ ! -z "$DOCKER_BRIDGE_IP" ]; then
  rm -f /etc/nginx/sites-available/default.conf
  cp docker/nginx/local.conf /etc/nginx/sites-available/default.conf
fi

# Start supervisord and services as root
exec /usr/bin/supervisord -n -c /etc/supervisord.conf

