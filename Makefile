
dcrust=$$( [ -f /.dockerenv ] && echo "" || echo "docker-compose exec rust")
dcpandoc=$$( [ -f /.dockerenv ] && echo "" || echo "docker-compose exec pandoc")

.PHONY: it
it: fmt target/debug ## Perform common targets

.PHONY: help
help: ## Displays this list of targets with descriptions
	@grep -E '^[a-zA-Z0-9_-]+:.*?## .*$$' $(firstword $(MAKEFILE_LIST)) | sort | awk 'BEGIN {FS = ":.*?## "}; {printf "\033[32m%-30s\033[0m %s\n", $$1, $$2}'
