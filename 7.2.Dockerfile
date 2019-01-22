FROM php:7.2-alpine
MAINTAINER koopzington@gmail.com

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        icu-dev \
        g++ \
        make \
        autoconf \
    " \
    runtimeDeps=" \
        git \
        openssh-client \
        bzip2-dev \
        libmemcached-dev \
        libpng-dev \
        libxml2-dev \
        gettext-dev \
        icu \
        postgresql-dev \
        libxslt-dev \
        openldap-dev \
        libzip \
    " \
    && apk update && apk add --no-cache $buildDeps $runtimeDeps

RUN docker-php-ext-install bcmath bz2 calendar gd gettext intl ldap mysqli opcache pdo_mysql pdo_pgsql pgsql soap xsl zip
RUN pecl install memcached redis xdebug \
    && docker-php-ext-enable memcached.so redis.so xdebug.so
RUN apk del $buildDeps \
    && rm -rf /tmp/*

# Install Composer.
ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
