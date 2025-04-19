#!/bin/bash

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
LOGS_DIR="${SCRIPT_DIR}/../logs"

mkdir -p "$LOGS_DIR"
rm -rf "${LOGS_DIR:?}"/*

docker cp nginx:/var/log/nginx/app-access.log "$LOGS_DIR/"
docker cp nginx:/var/log/nginx/app-error.log "$LOGS_DIR/"
docker cp phpfpm:/var/log/app-msmtp.log "$LOGS_DIR/"
docker cp phpfpm:/var/log/xdebug.log "$LOGS_DIR/"

#docker cp elasticsearch:/var/log/elasticsearch/elasticsearch.log "$LOGS_DIR/"
#docker cp elasticsearch:/var/log/elasticsearch/elasticsearch-slowlog.log "$LOGS_DIR/"
#
#docker cp db:/var/log/mysql/error.log "$LOGS_DIR/"
#docker cp db:/var/log/mysql/mysql.log "$LOGS_DIR/"
#
#docker cp db:/var/log/mysql/mysql-slow.log "$LOGS_DIR/"
#docker cp phpfpm:/var/log/php8.1-fpm.log "$LOGS_DIR/"

