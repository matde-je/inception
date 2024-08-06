FROM debian:bullseye

RUN apt-get update && apt-get upgrade && apt-get install -y curl php php7.4-fpm php-mysql mariadb-client netcat

COPY ./conf/conf.sh /

RUN chmod +x ./conf.sh

ENTRYPOINT [ "./conf.sh" ]

