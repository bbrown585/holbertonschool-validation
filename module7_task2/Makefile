CURRENT_GIT_REF = $(shell git tag --points-at HEAD)
ifeq ($(CURRENT_GIT_REF), )
	CURRENT_GIT_REF = $(shell git symbolic-ref --short HEAD)
endif

build-docker: ## Builds the Docker image based on ./build/Dockerfile
	docker compose build awesome-build

lint: ## Lint
	shellcheck setup.sh >/dev/null 2>&1 || echo "Lint Failed"
	shellcheck ensure-server-created.sh >/dev/null 2>&1 || echo "Lint Failed"
	shellcheck ensure-server-setup.sh >/dev/null 2>&1 || echo "Lint Failed"
	shellcheck deploy.sh >/dev/null 2>&1 || echo "Lint Failed"

.PHONY: build
build: clean ## Build with Hugo - requires that build-docker has been run
	docker run --cidfile="cidFile" awesome:build
	docker cp `cat cidFile`:/app/dist ./dist
	docker cp `cat cidFile`:/app/awesome-api ./awesome-api
	rm -f ./cidFile

test: build unit-tests integration-tests ## Test

unit-tests: build ## Unit Tests
	docker run --cidfile="cidFile" awesome:build go test -v -short -coverprofile=coverage-units.out
	docker cp `cat cidFile`:/app/coverage-units.out ./coverage-units.out
	rm -f ./cidFile

integration-tests: build ## Integration Tests
	docker run --cidfile="cidFile" awesome:build go test -v -short -coverprofile=coverage-integrations.out
	docker cp `cat cidFile`:/app/coverage-integrations.out ./coverage-integrations.out
	rm -f ./cidFile

validate: build ## Validate
	docker run awesome:build echo "PASS"

clean: ## Delete the dist/ directory
	rm -f ./cidFile
	rm -rf ./dist
	rm -f ./awesome-api
	rm -f ./awesome.log
	rm -f ./coverage-units.out
	rm -f ./coverage-integrations.out
	rm -f ./awesome-website.zip
	rm -f ./awesome.tar
	rm -f ./awesome.tar.zip
	rm -f ./awesome_image_tag_name.txt
	rm -f ./new_ec2_instance_public_ip.txt
	rm -f ./docker-compose.env
	rm -f ./jenkins/docker-compose.env
	rm -f ./jenkins/awesome-key.pem
	rm -f ./jenkins/awesome-key.pub

post: ## Create a new post
	docker run awesome:build echo '---' >> ./content/posts/$(POST_NAME).md
	docker run awesome:build echo "title: $(POST_TITLE)" >> ./content/posts/$(POST_NAME).md
	docker run awesome:build echo '---' >> ./content/posts/$(POST_NAME).md

help: ## Displays help for this makefile
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done

package: build ## Package
	echo "CURRENT_GIT_REF=$(CURRENT_GIT_REF)" > docker-compose.env
	docker compose --env-file docker-compose.env build awesome-static
	docker compose --env-file docker-compose.env build awesome-api
	docker compose --env-file docker-compose.env build reverse-proxy
	echo $(CURRENT_GIT_REF) > awesome_image_tag_name.txt

publish-docker-hub: # Pushes images to Docker Hub. Must be run after `make package`.
	docker compose push awesome-static
	docker compose push awesome-api
	docker compose push reverse-proxy

build-jenkins: clean # Build Jenkins
	cp ~/.ssh/awesome-key.pem ./jenkins/
	cp ~/.ssh/awesome-key.pub ./jenkins/
	cd ./jenkins && docker compose build
	
	rm -f ./jenkins/awesome-key.pem
	rm -f ./jenkins/awesome-key.pub

jenkins-up: build-jenkins # Jenkins up
# cd ./jenkins && docker compose --env-file ./docker-compose.env up
	cd ./jenkins && docker compose up

publish-docker-hub-jenkins: build-jenkins # Publish Jenkins and Jenkins Agent images to Docker Hub
	cd ./jenkins && docker compose push

ssh-keygen: # Makes a new keypair
	ssh-keygen -f jenkins-agent -t rsa -N "" -b 2048

docker-clean: # Prunes docker
	docker rm -f $(shell docker ps -a -q)
	docker volume rm $(shell docker volume ls -q)

create-server: # Create a new
	./ensure-server-created.sh jenkins
	./ensure-server-created.sh production

ansible-playbook: # Create a new
	ansible-playbook --inventory=./ansible/inventory.yml ./ansible/playbook.yml