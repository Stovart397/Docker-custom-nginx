FROM ubuntu:18.04

RUN apt-get update -y && \
    apt-get install nginx -y && \
    rm -frv /etc/nginx/nginx.conf

COPY /nginx.conf /etc/nginx/nginx.conf

RUN useradd --no-create-home nginx

ENTRYPOINT nginx -g 'daemon off;'

VOLUME ["/var/lib/nginx"]

WORKDIR /etc/nginx

CMD ["nginx", "-g", "daemon off;"]
