FROM php:8.1-fpm

# Install system dependencies
RUN apt-get update  \
    && apt-get install -y \
        libfreetype6-dev \
        libjpeg62-turbo-dev \
        libpng-dev \
        libzip-dev \
        libicu-dev \
        libxml2-dev \
        libxslt1-dev \
        libonig-dev \
        libssl-dev \
        libcurl4-openssl-dev \
        libgmp-dev \
        unzip \
        zip \
        git \
        curl \
        gnupg \
        default-mysql-client \
        libmcrypt-dev \
        msmtp \
    && docker-php-source extract \
    && docker-php-ext-configure gd --with-freetype --with-jpeg \
    && docker-php-ext-install -j$(nproc) gd

# Install PHP extensions
RUN docker-php-ext-install \
    bcmath \
    curl \
    dom \
    gd \
    gmp \
    intl \
    mbstring \
    mysqli \
    pdo_mysql \
    soap \
    xsl \
    zip \
    xml \
    opcache

# Install Composer globally
RUN curl -sS https://getcomposer.org/installer | php -- --install-dir=/usr/local/bin --filename=composer

# Clean up
RUN apt-get clean && rm -rf /var/lib/apt/lists/* /tmp/* /var/tmp/*

COPY ./bin/start.sh /usr/local/bin/start.sh
COPY ./config/php.ini /usr/local/etc/php/php.ini
COPY ./config/www.conf /usr/local/etc/php-fpm.d/www.conf
COPY ./config/msmtprc /etc/msmtprc

RUN chmod +x /usr/local/bin/start.sh

WORKDIR /var/www/html

CMD ["/usr/local/bin/start.sh"]
