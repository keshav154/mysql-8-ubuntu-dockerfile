FROM ubuntu:18.04

ENV DEBIAN_FRONTEND noninteractive

RUN apt-get update
RUN apt-get install -yq curl php gnupg wget sudo lsb-release debconf-utils

RUN curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add - \
&& echo 'deb https://dl.yarnpkg.com/debian/ stable main' | tee /etc/apt/sources.list.d/yarn.list \
&& apt-get update && apt-get install -yq yarn \
&& echo 'mysql-community-server mysql-community-server/root-pass password root' | debconf-set-selections \
&& echo 'mysql-community-server mysql-community-server/re-root-pass password root' | debconf-set-selections \
&& echo 'mysql-community-server mysql-server/default-auth-override select Use Legacy Authentication Method (Retain MySQL 5.x Compatibility)' | debconf-set-selections \
&& wget -c https://dev.mysql.com/get/mysql-apt-config_0.8.15-1_all.deb && dpkg -i mysql-apt-config_0.8.15-1_all.deb \
&& sudo apt-get update && apt-get install -y mysql-server \
&& echo " \n\
[program: mysql] \n\
command = nohup mysqld_safe --user=root \n\
autostart = true \n\
autorestart = false \n\
" > /etc/supervisor/conf.d/mysql.conf
CMD ["supervisord"]
