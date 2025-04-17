FROM nginx:1.27

ENV PHP_HOST phpfpm
ENV PHP_PORT 9000
ENV APP_MAGE_MODE default

RUN apt-get install -y openssl && rm -rf /var/lib/apt/lists/*

RUN mkdir -p /etc/nginx/certs \
    && openssl req -x509 -nodes -days 365 -newkey rsa:2048 -keyout /etc/nginx/certs/ssl-cert-nginx.key -out /etc/nginx/certs/ssl-cert-nginx.pem -subj "/C=US/ST=Test/L=Dev/O=Magento/CN=docker_magento.local"

COPY ./conf/nginx.conf /etc/nginx/
COPY ./conf/default.conf /etc/nginx/conf.d/
COPY ./bin/start.sh /usr/local/bin/start.sh

EXPOSE 8080
EXPOSE 4433

WORKDIR /var/www/html

CMD ["/usr/local/bin/start.sh"]
