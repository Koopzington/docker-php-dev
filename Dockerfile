FROM php:alpine
MAINTAINER koopzington@gmail.com

# Install PHP extensions and PECL modules.
RUN buildDeps=" \
        bzip2-dev \
        libmemcached-dev \
        icu-dev \
    " \
    runtimeDeps=" \
        git \
        openssh-client \
        libpng-dev \
        libxml2-dev \
        gettext-dev \
        icu \
        postgresql-dev \
        libxslt-dev \
        openldap-dev \
    " \
    && apk update && apk add --no-cache -y $buildDeps $runtimeDeps \
    && docker-php-ext-install bcmath bz2 calendar gd gettext iconv intl ldap mysqli opcache pdo_mysql pdo_pgsql  \
    && docker-php-ext-install pdo_sqlite pgsql soap xsl zip \
    && pecl install memcached redis xdebug \
    && docker-php-ext-enable memcached redis xdebug \
    && apk del $buildDeps \
    && rm -r /var/lib/apt/lists/*

# Install Composer.
ENV COMPOSER_HOME /root/composer
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer
ENV PATH $COMPOSER_HOME/vendor/bin:$PATH
