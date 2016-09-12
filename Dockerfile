FROM ubuntu:xenial
MAINTAINER Neil Calabroso <ncalabroso@gmail.com>

# Add the project directory
ADD . /mnt/gotify
WORKDIR /mnt/gotify

# Install basic dependencies
RUN apt-get update -y && apt-get upgrade -y && apt-get install -y build-essential curl git --fix-missing

# Install Go Version Manager
RUN ["/bin/bash", "-c", "bash < <(curl -s -S -L https://raw.githubusercontent.com/moovweb/gvm/master/binscripts/gvm-installer)"]

# Install Go
RUN ["/bin/bash", "-c", "source ~/.gvm/scripts/gvm", "&&", "gvm install go1.4", "&&", "gvm use go1.4", "&&", "gvm install go1.7", "&&", "gvm use go1.7"]

# Install mysql
ARG DEBIAN_FRONTEND=noninteractive
RUN { \
    echo mysql-community-server mysql-community-server/data-dir select ''; \
    echo mysql-community-server mysql-community-server/root-pass password ''; \
    echo mysql-community-server mysql-community-server/re-root-pass password ''; \
    echo mysql-community-server mysql-community-server/remove-test-db select false; \
  } | debconf-set-selections \
  && apt-get install -y mysql-server

# Install nginx
RUN apt-get install -y nginx

# Expose port to be linked to other containers
EXPOSE 80 443

# Run Application
CMD ["nginx", "-g", "daemon off;"]
