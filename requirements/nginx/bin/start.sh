#!/bin/bash
[ ! -z "${PHP_HOST}" ]                 && sed -i "s/PHP_HOST/${PHP_HOST}/" /etc/nginx/conf.d/default.conf
[ ! -z "${PHP_PORT}" ]                 && sed -i "s/PHP_PORT/${PHP_PORT}/" /etc/nginx/conf.d/default.conf
[ ! -z "${APP_MAGE_MODE}" ]            && sed -i "s/APP_MAGE_MODE/${APP_MAGE_MODE}/" /etc/nginx/conf.d/default.conf

echo "127.0.0.1     docker_magento.local" >> /etc/hosts

echo "=============================\n";
echo "============NGINX============\n";
echo "=============================\n";

/usr/sbin/nginx -g "daemon off;"
