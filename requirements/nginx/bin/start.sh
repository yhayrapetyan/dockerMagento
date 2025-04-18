#!/bin/bash

# Fail fast if required environment variables are missing
: "${SSL_KEY:?Missing SSL_KEY}"
: "${SSL_CRT:?Missing SSL_CRT}"
: "${SERVER_NAME:?Missing SERVER_NAME}"
: "${PHP_HOST:?Missing PHP_HOST}"
: "${PHP_PORT:?Missing PHP_PORT}"
: "${APP_MAGE_MODE:?Missing APP_MAGE_MODE}"

mkdir -p /etc/nginx/certs
openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout ${SSL_KEY} -out ${SSL_CRT} -subj "/C=US/ST=Test/L=Dev/O=Magento/CN=${SERVER_NAME}" &> /dev/null

[ ! -z "${PHP_HOST}" ]      && sed -i "s|PHP_HOST|${PHP_HOST}|" /etc/nginx/conf.d/default.conf
[ ! -z "${PHP_PORT}" ]      && sed -i "s|PHP_PORT|${PHP_PORT}|" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_MAGE_MODE}" ] && sed -i "s|APP_MAGE_MODE|${APP_MAGE_MODE}|" /etc/nginx/conf.d/default.conf
[ ! -z "${SSL_CRT}" ]       && sed -i "s|SSL_CRT|${SSL_CRT}|" /etc/nginx/conf.d/default.conf
[ ! -z "${SSL_KEY}" ]       && sed -i "s|SSL_KEY|${SSL_KEY}|" /etc/nginx/conf.d/default.conf
[ ! -z "${SERVER_NAME}" ]   && sed -i "s|SERVER_NAME|${SERVER_NAME}|" /etc/nginx/conf.d/default.conf

echo "127.0.0.1     ${SERVER_NAME}" >> /etc/hosts

echo "=============================";
echo "============NGINX============";
echo "=============================";

/usr/sbin/nginx -g "daemon off;"
