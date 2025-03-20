# Define the commands and packages
BREW := /usr/local/bin/brew
HELM := /usr/local/bin/helm
GCLOUD := /usr/local/bin/gcloud
GIT := /usr/bin/git
KUBECTL := /usr/local/bin/kubectl
NPM := /usr/local/bin/npm

all: install

install: install_brew install_git install_helm install_gcloud install_kubectl install_npm

install_brew:
	@if ! command -v brew >/dev/null 2>&1; then \
		echo "Homebrew not found. Installing..."; \
		/bin/bash -c "$$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"; \
	else \
		echo "Homebrew is already installed."; \
	fi

install_git:
	@if ! command -v git >/dev/null 2>&1; then \
		echo "Git not found. Installing..."; \
		$(BREW) install git; \
	else \
		echo "Git is already installed."; \
	fi

install_helm:
	@if ! command -v helm >/dev/null 2>&1; then \
		echo "Helm not found. Installing..."; \
		$(BREW) install helm; \
	else \
		echo "Helm is already installed."; \
	fi


install_kubectl:
	@if ! command -v kubectl >/dev/null 2>&1; then \
		echo "kubectl not found. Installing..."; \
		$(BREW) install kubectl; \
	else \
		echo "kubectl is already installed."; \
	fi

run-app:
	cd my-app-local/password-generator-app && \
	if [ ! -f .env ]; then \
		mv data .env; \
	fi && \
	npm install && npm start

docker-build:
	docker buildx build  --platform linux/amd64 -t thiagousa/password-generator-app:latest my-app-local/password-generator-app

docker-run: 
	docker run -itd -p 3000:3000 --name=password thiagousa/password-generator-app:latest

docker-check:
	docker ps | grep -i password

docker-logs:
	docker logs -f password	 
    
docker-remove: 
	docker rm password --force

docker-push: 
	docker push thiagousa/password-generator-app:latest

docker-pull: 
	docker pull thiagousa/password-generator-app:latest

load-test-install:
	npm install -g artillery

load-test-start:	
	artillery run my-app-local/password-generator-app/loadtest/loadtest.yaml

kubernetes-context:
	kubectl config get-contexts

kubernetes-select:
	kubectl config use-context rancher-desktop 



.PHONY: all install install_brew install_git install_helm install_gcloud install_kubectl run-app docker-build docker-run docker-check docker-logs docker-remove docker-push docker-pull load-test-install load-test-start kubernetes-context kubernetes-select helm-create helm-install helm-deploy kubernetes-check kubernetes-forward gcloud-login gcloud-config gcloud-check-project cloud-build cloud-deploy cloud-delete
