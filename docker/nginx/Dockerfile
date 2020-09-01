FROM ubuntu:20.04

LABEL maintainer="Marcel Gascoyne <marcel@gascoyne.de>"
LABEL description="Nginx container for Symfony 5"

RUN export DEBIAN_FRONTEND=noninteractive && \
    apt-get -y update && \
    apt-get install -y \
      software-properties-common \
      curl \
      gnupg2 \
      ca-certificates \
      lsb-release && \
    echo "deb http://nginx.org/packages/ubuntu `lsb_release -cs` nginx" \
      | tee /etc/apt/sources.list.d/nginx.list && \
    curl -fsSL https://nginx.org/keys/nginx_signing.key | apt-key add - && \
    apt-get -y update && \
    apt-get install -y nginx

# Nginx config
ADD nginx.conf /etc/nginx

# Data folder
RUN mkdir -p /data
RUN chown -R www-data:www-data /data

# Volumes
VOLUME /data
VOLUME /app

# Ports
EXPOSE 8080

WORKDIR /app
CMD ["nginx"]
