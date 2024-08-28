all: up

#start containers in background and leave them running
#create network and volumes
up: build
	mkdir -p /home/matde-je/data/wordpress
	mkdir -p /home/matde-je/data/mariadb 
	chmod -R 755 /home/matde-je/data/wordpress
	chmod -R 755 /home/matde-je/data/mariadb
	docker-compose -f ./srcs/docker-compose.yml up -d 

start:
	docker-compose -f ./srcs/docker-compose.yml start

#build images
build:
	docker-compose -f ./srcs/docker-compose.yml build 

clean:
	@docker stop $$(docker ps -qa) || true	#lists all container IDs 
	@docker rm $$(docker ps -qa) || true 
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
	@rm -rf /home/matde-je/data/wordpress || true
	@rm -rf /home/matde-je/data/mariadb  || true

re: clean up
