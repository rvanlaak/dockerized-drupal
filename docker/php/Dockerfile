FROM php:8.2-fpm-alpine as app

WORKDIR /app

RUN set -xe \
    && apk add openssl-dev --no-cache --update --virtual .phpize-deps $PHPIZE_DEPS \
    && apk add pcre pcre-dev gcc make libc-dev libpng-dev \
    && rm -rf /usr/share/php \
    && rm -rf /tmp/* \
    && apk del .phpize-deps

RUN apk add --no-cache oniguruma-dev zip libzip-dev
RUN docker-php-ext-configure zip
RUN docker-php-ext-install pdo pdo_mysql mysqli opcache mbstring gd pcntl zip \
    && docker-php-ext-enable opcache zip

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
