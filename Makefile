#!make
APP_NAME=vm_deployer
COMMAND_ARGS:= $(subst :,\:,$(COMMAND_ARGS))$
PWD=`pwd`

env ?= .env
-include $(env)
export $(shell sed 's/=.*//' $(env))

doc:
	echo "Check the doc here: https://github.com/Maissacrement/azureDeploy/tree/main"

kill:
	@docker rm -f /$(APP_NAME);echo 1;
	@docker rm -f $(APP_NAME);echo 1;
	
.PHONY: deploy
deploy: kill
	echo "$(PARAM)"
	@docker run -i --rm -d --name $(APP_NAME) \
		-v "${PWD}/$(PARAM):/home/$(PARAM)" \
		-v /var/run/docker.sock:/var/run/docker.sock \
		--env-file=.env \
	docker.io/maissacrement/ansibledind:latest

deploy_file: deploy
	@docker exec -it $(APP_NAME) /bin/bash -c "ansible-playbook /home/$(PARAM)"
	@docker rm -f /$(APP_NAME);echo 1;