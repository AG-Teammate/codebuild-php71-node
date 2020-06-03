FROM php:7.1-alpine

RUN mkdir /app

RUN apk add --no-cache \
		curl \
		curl-dev \
        libcurl \
        libjpeg \
        libjpeg-turbo-dev \
        libpng \
        libpng-dev \
        libbz2 \
        freetype \
        freetype-dev \
        libssl1.1 \
        libmcrypt-dev \
        libmemcached-dev \
        libmcrypt-dev \
        libxml2-dev     \
        openssh-client     \
        nodejs \
        git \
    && rm -rf /var/cache/apk/*

RUN docker-php-ext-install mcrypt
RUN docker-php-ext-install pdo_mysql
RUN docker-php-ext-install curl
RUN docker-php-ext-install xml
RUN docker-php-ext-install zip
RUN docker-php-ext-install exif

RUN docker-php-ext-configure gd \
        --enable-gd-native-ttf \
        --with-jpeg-dir=/usr/lib \
        --with-freetype-dir=/usr/include/freetype2 && \
    docker-php-ext-install gd

USER root

RUN [ ! -f "composer.phar" ] && wget http://getcomposer.org/composer.phar
RUN mv composer.phar /usr/local/bin/composer
RUN /bin/chmod +x /usr/local/bin/composer

RUN composer self-update
RUN composer global require "squizlabs/php_codesniffer=*"
RUN composer global require "phpmd/phpmd"
RUN composer global require "phpunit/phpunit=~5.7"
RUN composer global require "laravel/envoy=~1.0"

ENV PATH="/root/.composer/vendor/bin:${PATH}"

COPY . /app

EXPOSE 8008

WORKDIR /tmp
