FROM debian:bullseye

RUN apt-get update && apt-get upgrade -y && apt-get install -y mariadb-server 
# -y to automatically answer yes to all prompts

COPY ./config.sh /config.sh 
# dest path inside the Docker image, says config.sh to be copied to root dir (/) of Docker image

RUN chmod +x /config.sh
#executable 

ENTRYPOINT [ "./config.sh" ]
