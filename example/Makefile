.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan -var="project=${GOOGLE_PROJECT}" -var="credentials=${GOOGLE_APPLICATION_CREDENTIALS}"

.PHONY: apply
apply:
	terraform apply -var="project=${GOOGLE_PROJECT}" -var="credentials=${GOOGLE_APPLICATION_CREDENTIALS}" --auto-approve

.PHONY: destroy
destroy:
	terraform destroy -var="project=${GOOGLE_PROJECT}" -var="credentials=${GOOGLE_APPLICATION_CREDENTIALS}" --auto-approve

.PHONY: ssh/proxy/mtls
ssh/proxy/mtls: ## Forwards the Consul and Nomad server port to localhost, using the custom mTLS terminating proxy script
	@go run ../ssh-mtls-terminating-proxy.go
