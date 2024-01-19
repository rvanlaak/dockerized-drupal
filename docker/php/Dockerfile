FROM php:8.2-fpm-alpine as app

WORKDIR /app

RUN set -xe \
    && apk add openssl-dev --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add pcre pcre-dev gcc make libc-dev \
    && rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && apk del .phpize-deps

RUN apk add --no-cache oniguruma-dev zip libzip-dev && \
    docker-php-ext-configure zip && \
    docker-php-ext-install zip && \
    docker-php-ext-enable zip

RUN docker-php-ext-install pdo pdo_mysql mysqli opcache mbstring pcntl \
    && docker-php-ext-enable opcache

RUN apk add --no-cache $PHPIZE_DEPS \
        freetype-dev \
        libjpeg-turbo-dev \
        libpng-dev && \
    docker-php-ext-configure gd --with-jpeg --with-webp --with-freetype; \
    docker-php-ext-install -j$(nproc) gd

# this might be increased for larger size project
# https://www.scalingphpbook.com/blog/2014/02/14/best-zend-opcache-settings.html
# https://tideways.com/profiler/blog/fine-tune-your-opcache-configuration-to-avoid-caching-suprises
RUN { \
        echo 'opcache.memory_consumption=128'; \
        echo 'opcache.interned_strings_buffer=8'; \
        echo 'opcache.max_accelerated_files=4000'; \
        echo 'opcache.revalidate_freq=0'; \
        echo 'opcache.fast_shutdown=1'; \
        echo 'opcache.enable_cli=1'; \
        echo 'opcache.validate_timestamps=0';\
    } > /usr/local/etc/php/conf.d/opcache-recommended.ini

FROM app as dev

COPY --from=composer:latest /usr/bin/composer /usr/local/bin/composer

RUN apk add --update linux-headers \
    && pecl install xdebug \
    && docker-php-ext-enable xdebug \
