FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y nginx openssl

RUN mkdir -p /etc/nginx/ssl
#-p no error raised if dir exists

RUN openssl req -x509 -nodes -out /etc/nginx/ssl/inception.crt -keyout /etc/nginx/ssl/inception.key -subj "/C=PT/ST=LIS/L=LIS/O=42/OU=42/CN=matde-je.42.fr"
#self signed certificate 
#-nodes avoid any prompts that require manual input. Encrypting the private key would prompt for a passphrase whenever the key is used, which is not suitable for automated processes

#create dir for WordPress files
RUN mkdir -p /var/www/wordpress && chown -R www-data:www-data /var/www/wordpress
#set ownership of the dir recursively all files to default user

COPY ./nginx.conf /etc/nginx/nginx.conf

CMD ["nginx", "-g", "daemon of;"]
#run in foreground
