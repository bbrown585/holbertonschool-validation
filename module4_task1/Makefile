build-docker: ## Build docker image
	docker build -f ./build/Dockerfile -t awesome:build .
lint: ## Lint
	shellcheck setup.sh >/dev/null 2>&1 || echo "Lint Failed"
.PHONY: build
build: clean ## Build with Hugo
	docker run --cidfile="cidFile" awesome:build /bin/bash -c "hugo; go build"
	docker cp `cat cidFile`:/app/dist ./dist
	docker cp `cat cidFile`:/app/awesome-api ./awesome-api
	rm -f ./cidFile	

test: unit-tests integration-tests ## Test

unit-tests:	## Unit Tests
	docker run --cidfile="cidFile" awesome:build go test -v -short -coverprofile=coverage-units.out
	docker cp `cat cidFile`:/app/coverage-units.out ./coverage-units.out
	rm -f ./cidFile

integration-tests: ## Integration Tests
	docker run --cidfile="cidFile" awesome:build go test -v -coverprofile=coverage-integrations.out
	docker cp `cat cidFile`:/app/coverage-integrations.out ./coverage-integrations.out
	rm -f ./cidFile

validate: ## Validate
	echo "PASS"

clean: ## Delete the dist/ directory
	rm -f ./cidFile
	rm -rf dist
	rm -f ./awesome-api
	rm -f ./awesome.log
	rm -f ./coverage-units.out
	rm -f ./coverage-integrations.out
	rm -f ./awesome-website.zip

post: ## Create a new post
	echo '---' >> ./content/posts/$(POST_NAME).md
	echo "title: $(POST_TITLE)" >> ./content/posts/$(POST_NAME).md
	echo '---' >> ./content/posts/$(POST_NAME).md

package: build ## Package
	docker run --cidfile="cidFile" -v dist:/app/dist -v awesome-api:/app/awesome-api awesome:build zip -r awesome-website.zip dist awesome-api
	docker cp `cat cidFile`:/app/awesome-website.zip ./awesome-website.zip
	rm -f ./cidFile

help: ## Displays help for this makefile
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
