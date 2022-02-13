# Docker-custom-nginx

## Task's
1. Write a Dockerfile with the following configuration:
- built from `ubuntu:18.04`image,
- it installs the nginx package,
- your custom `nginx file` is copied into it
- `ENTRYPOINT` uses nginx launch,
- the same nginx startup options as in the `nginx:stable` image should be defined in CMD (usually the nginx startup line looks like this `nginx -g deamon off`; )
- the main working directory inside the container is `/etc/nginx/`,
- the Volume must be defined with the path `/var/lib/nginx`.
2. Build this image with the name `nginx:your-name`,
3. List the images on your host.
4. Run the container with the following options:
- should work in the background,
- listening on host `127.0.0.1:8901`.
5. Print a list of running containers - the container must be running.
6. Check the work by referring to 127.0.0.1:8901 - in response it should return the string `Welcome to the CUSTOM NGINX CONFIG FILE`
7. Push Docker image in DockerHUB 
8. Bro you are the best!

## Solution
1. Make `nginx.conf` and `Dockerfile`
2. `nginx.conf`  
``` 
user  www-data;
worker_processes  auto;

error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;


events {
    worker_connections  1024;
}


http {
    include       /etc/nginx/mime.types;
    default_type  application/octet-stream;

    log_format  main  '$remote_addr - $remote_user [$time_local] "$request" '
                      '$status $body_bytes_sent "$http_referer" '
                      '"$http_user_agent" "$http_x_forwarded_for"';

    access_log  /var/log/nginx/access.log  main;

    sendfile        on;
    tcp_nopush     on;

    keepalive_timeout  65;

    gzip  on;


    server {
        listen 80;

        location = / {
            add_header Content-Type text/plain always;
            return 200 'Welcome to the CUSTOM NGINX CONFIG FILE\n';
        }
    }

}
```
3. `Dockerfile`
``` 
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
```
## Build Container
`docker build . -t nginx:your-name`
## RUN Container
`docker run -d --name your-name -p 127.0.0.1:8901:80
nginx:your-name`
## View Container
`docker ps -a`

`curl -i 127.0.0.1:8901`  
INPUT   `Welcome to the CUSTOM NGINX CONFIG FILE`
