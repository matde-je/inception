all: up

#start containers in background and leave them running
up: build
	sudo mkdir -p /home/data/wordpress
	sudo mkdir -p /home/data/mariadb 
	docker-compose -f ./srcs/docker-compose.yml up -d

#stop containers
down:
	docker-compose -f ./srcs/docker-compose.yml down

#containers remain on the system and can be restarted later
stop:
	docker-compose -f ./srcs/docker-compose.yml stop

start:
	docker-compose -f ./srcs/docker-compose.yml start

build:
	docker-compose -f ./srcs/docker-compose.yml build

clean:
	@docker stop $$(docker ps -qa) || true	#lists all container IDs 
	@docker rm $$(docker ps -qa) || true 
	@docker rmi -f $$(docker images -qa) || true
	@docker volume rm $$(docker volume ls -q) || true
	@docker network rm $$(docker network ls -q) || true
	@rm -rf /home/data/wordpress || true
	@rm -rf /home/data/mariadb  || true

re: clean up

#deep cleaning
prune: clean
	@docker system prune -a --volumes -f