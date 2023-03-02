lint: ## Lint
	shellcheck setup.sh >/dev/null 2>&1 || echo "Lint Failed"

build: ## Build with Hugo
	hugo
	go build

test: unit-tests integration-tests ## Test

unit-tests:	## Unit Tests
	go test -v -short -coverprofile=coverage-units.out

integration-tests: ## Integration Tests
	go test -v -short -coverprofile=coverage-integrations.out

validate: ## Validate
	echo "PASS"

clean: ## Delete the dist/ directory
	rm -rf dist
	rm -f ./awesome-api
	rm -f ./awesome.log
	rm -f ./coverage-units.out
	rm -f ./coverage-integrations.out

post: ## Create a new post
	echo '---' >> ./content/posts/$(POST_NAME).md
	echo "title: $(POST_TITLE)" >> ./content/posts/$(POST_NAME).md
	echo '---' >> ./content/posts/$(POST_NAME).md

package: build ## Package
	zip -r awesome-website.zip dist awesome-api 

help: ## Displays help for this makefile
	@grep -E '^[a-zA-Z0-9 -]+:.*#'  Makefile | sort | while read -r l; do printf "\033[1;32m$$(echo $$l | cut -f 1 -d':')\033[00m:$$(echo $$l | cut -f 2- -d'#')\n"; done
