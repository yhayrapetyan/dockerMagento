#!/bin/bash

: "${SERVER_NAME:?Missing SERVER_NAME}"
: "${MAILPIT_HOST:?Missing MAILPIT_HOST}"
: "${MAILPIT_PORT:?Missing MAILPIT_PORT}"

[ ! -z "${SERVER_NAME}" ]   && sed -i "s|SERVER_NAME|${SERVER_NAME}|" /etc/msmtprc/msmtprc
[ ! -z "${MAILPIT_HOST}" ]   && sed -i "s|MAILPIT_HOST|${MAILPIT_HOST}|" /etc/msmtprc/msmtprc
[ ! -z "${MAILPIT_PORT}" ]   && sed -i "s|MAILPIT_PORT|${MAILPIT_PORT}|" /etc/msmtprc/msmtprc

# All of the provided changes already applied to php.ini from config
# sed -i "s/memory_limit = .*/memory_limit = 1G/" /etc/php/8.1/cli/php.ini
# sed -i "s/upload_max_filesize = .*/upload_max_filesize = 128M/" /etc/php/8.1/cli/php.ini
# sed -i "s/zlib.output_compression = .*/zlib.output_compression = on/" /etc/php/8.1/cli/php.ini
# sed -i "s/max_execution_time = .*/max_execution_time = 18000/" /etc/php/8.1/cli/php.ini
# sed -i "s/;realpath_cache_size = .*/realpath_cache_size = 10M/" /etc/php/8.1/cli/php.ini
# sed -i "s/;realpath_cache_ttl = .*/realpath_cache_ttl = 7200/" /etc/php/8.1/cli/php.ini

echo "=============================";
echo "============FPM==============";
echo "=============================";

php-fpm