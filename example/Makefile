.PHONY: init
init:
	terraform init

.PHONY: plan
plan:
	terraform plan -var="project=${GOOGLE_PROJECT}" -var="credentials=${GOOGLE_APPLICATION_CREDENTIALS}" -out=tfplan

.PHONY: apply
apply:
	terraform apply -var="project=${GOOGLE_PROJECT}" -var="credentials=${GOOGLE_APPLICATION_CREDENTIALS}" --auto-approve

.PHONY: destroy
destroy:
	terraform destroy -var="project=${GOOGLE_PROJECT}" -var="credentials=${GOOGLE_APPLICATION_CREDENTIALS}" --auto-approve

.PHONY: ssh/proxy/mtls
ssh/proxy/mtls: ## Forwards the Consul and Nomad server port to localhost, using the custom mTLS terminating proxy script
	@go run ../ssh-mtls-terminating-proxy.go

.PHONY: consul/metrics/acls
consul/metrics/acls: ## Create a Consul policy, role, and token to use with prometheus
	@echo "📑 Creating Consul ACL Policy"
	@consul acl policy create -name "resolve-any-upstream" -rules 'service_prefix "" { policy = "read" } node_prefix "" { policy = "read" } agent_prefix "" { policy = "read" }' -token=$(shell terraform output consul_master_token)
	@echo "🎭 Creating Consul ACL Role"
	@consul acl role create -name "metrics" -policy-name  "resolve-any-upstream" -token=$(shell terraform output consul_master_token)
	@echo "🔑 Creating Consul ACL Token to Use for Prometheus Consul Service Discovery"
	@consul acl token create -role-name "metrics" -token=$(shell terraform output consul_master_token)

.PHONY: nomad/logs
nomad/logs: ## Runs a Loki and Promtail jobs on Nomad
	@nomad run ../jobs/logs/loki.hcl
	@nomad run ../jobs/logs/promtail.hcl

.PHONY: nomad/ingress
nomad/ingress: ## Runs a Traefik proxy to handle ingress traffic across the cluster
	@nomad run ../jobs/ingress/traefik.hcl

.PHONY: nomad/metrics
nomad/metrics: ## Runs a Prometheus and Grafana stack on Nomad
	@nomad run -var='consul_targets=[$(shell terraform output -json | jq -r '(.server_internal_ips.value + .client_internal_ips.value) | map(.+":8501") |  @csv')]' -var="consul_acl_token=$(consul_acl_token)" -var="consul_lb_ip=$(shell terraform output load_balancer_ip)" ../jobs/metrics/metrics.hcl
