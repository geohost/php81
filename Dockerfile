FROM ubuntu:20.04
LABEL maintainer="George Draghici <george@geohost.ro>"

ARG WEBROOT=/app

# Setting frontend Noninteractive
RUN echo 'debconf debconf/frontend select Noninteractive' | debconf-set-selections

# Avoid ERROR: invoke-rc.d: policy-rc.d denied execution of start.
RUN echo "#!/bin/sh\nexit 0" > /usr/sbin/policy-rc.d

RUN apt-get update && apt-get install -y software-properties-common
RUN LC_ALL=C.UTF-8 add-apt-repository -y ppa:ondrej/php

# Install supervisor, mysql-client, php-fpm, composer
RUN apt update ; \
    apt install -y \
    build-essential \
    software-properties-common ; \
    apt-get update ; \
    apt-get install -y \
    wget \
    nano \
    curl \
    unzip \
    php8.1-redis \
    php8.1-cli \
    php8.1-fpm \
    php8.1-bz2 \
    php8.1-bcmath \
    php8.1-curl \
    php8.1-gd \
    php8.1-mbstring \
    php8.1-xml \
    php8.1-xmlrpc \
    php8.1-zip \
    php8.1-opcache \
    php8.1-cgi \
    php8.1-xml \
    php8.1-mysql \
    php8.1-pgsql \
    php8.1-imagick \
    php8.1-soap \
    libmysqlclient-dev \
    mysql-client \
    imagemagick \
    mailutils \
    net-tools \
    supervisor \
    cron

# Install Composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer


# Copy php.ini file
ADD conf/php/php.ini /etc/php/8.1/fpm/php.ini
RUN mkdir -p /var/log/php
RUN touch /var/log/php/php-error.log && chown -R www-data:www-data /var/log/php

#Create docroot directory , copy code and Grant Permission to docroot
RUN mkdir -p $WEBROOT
RUN chown -R www-data:www-data $WEBROOT

ADD conf/php/www.conf /etc/php/8.1/fpm/pool.d/www.conf
ADD conf/supervisord.conf /etc/supervisor/supervisord.conf


# Enable www-data user shell
RUN chsh -s /bin/bash www-data

# Clean
RUN apt remove -y \
    build-essential software-properties-common && rm -rf /var/lib/apt/lists/*

EXPOSE 9000

COPY docker-entrypoint.sh /docker-entrypoint.sh
RUN chmod +x /docker-entrypoint.sh

CMD ["/docker-entrypoint.sh"]
