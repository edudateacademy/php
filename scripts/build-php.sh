#!/bin/bash
# run this file with: $sudo scripts/build-php.sh
tar xzf packages/php-8.1.7.tar.gz 
tar xzf packages/xdebug-3.1.5.tgz
cd php-8.1.7
apt install -y \
    build-essential \
    nginx \
    autoconf \
    pkgconf \
    libxml2-dev  \
    libsqlite3-dev \
    zlib1g-dev \
    libcurl4-openssl-dev \
    libsodium-dev \
    libssl-dev \
    libcurl4-openssl-dev \
    libpng-dev \
    libssl-dev \
    libjpeg-dev \
    libzip-dev \
    libmysqlclient-dev \
    re2c \
    bison \
    libonig-dev \
    libfcgi-dev \
    libfcgi0ldbl \
    libxpm-dev \
    libgd-dev \
    libfreetype6-dev \
    libxslt1-dev \
    libpspell-dev \
    libgccjit-10-dev \
    libsystemd-dev \
    libwebp-dev \
    php-dev \


#.configure --help
./configure --prefix /usr/local \
            --enable-fpm \
            --enable-debug \
            --with-fpm-user=www-data \
            --with-fpm-group=www-data \
            --enable-cli \
            --with-fpm-systemd \
            --with-openssl \
            --with-zlib \
            --with-curl \
            --enable-gd \
            --with-webp \
            --with-jpeg \
            --enable-intl \
            --enable-mbstring \
            --with-mysqli \
            --with-mysql-sock=/var/run/php \
            --with-pdo-mysql \
            --enable-opcache \
            --enable-sockets \
            --enable-soap \
            --enable-zend-test \
            --with-zip \
            --with-pear \
            --with-sodium
echo "N" | make test 
make install
cp ../scripts/php.ini.development /usr/local/lib/php.ini
cp ../scripts/www.conf.development /usr/local/etc/php-fpm.d/www.conf
cp sapi/fpm/php-fpm /usr/local/bin
cp ../scripts/php-fpm-service /usr/local/bin
cp ../scripts/php-fpm.conf.development /usr/local/etc/php-fpm.conf
cp sapi/fpm/php-fpm.service /lib/systemd/system
# systemctl enable php-fpm.service
# systemctl start php-fpm

cp ../scripts/edudate-app-virtual-host /etc/nginx/sites-available/edudate-app 
ln -s /etc/nginx/sites-available/edudate-app /etc/nginx/sites-enabled/edudate-app

pecl channel-update pecl.php.net
pecl install grpc protobuf
cd ..
curl -sS https://getcomposer.org/installer -o composer-setup.php
php composer-setup.php --install-dir=/usr/local/bin --filename=composer
cd xdebug-3.1.5
phpize
./configure
make
cp modules/xdebug.so /usr/local/lib/php/extensions/debug-non-zts-20210902

cd ..
# php-fpm-service start
# service nginx restart
