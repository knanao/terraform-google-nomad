datacenter = "dc1"
bind_addr = "0.0.0.0"
data_dir = "/etc/nomad.d/data"

leave_on_terminate = true
leave_on_interrupt = true

advertise {
  http = "{PRIVATE-IPV4}"
  rpc  = "{PRIVATE-IPV4}"
  serf = "{PRIVATE-IPV4}"
}

log_level = "TRACE"

server {
  enabled = true

  //server_join {
  //  retry_join     = ["provider=gce project_name={PROJECT-NAME} tag_value=server"]
  //  retry_max      = 12
  //  retry_interval = "10s"
  //}

  bootstrap_expect = {NUMBER-OF-SERVERS}

  encrypt = "{GOSSIP-KEY}"

  default_scheduler_config {
    scheduler_algorithm             = "spread"
    memory_oversubscription_enabled = true
    reject_job_registration         = false
    pause_eval_broker               = false # New in Nomad 1.3.2

    preemption_config {
      batch_scheduler_enabled    = true
      system_scheduler_enabled   = true
      service_scheduler_enabled  = true
      sysbatch_scheduler_enabled = true # New in Nomad 1.2
    }
  }
}

acl {
  enabled = {ACLs-ENABLED}
}

tls {
  http = true
  rpc  = true

  ca_file   = "/etc/nomad.d/nomad-ca.pem"
  cert_file = "/etc/nomad.d/server.pem"
  key_file  = "/etc/nomad.d/server-key.pem"

  verify_server_hostname = true
  verify_https_client    = true
}

consul {
  ssl          = true
  verify_ssl   = true
  address      = "127.0.0.1:8501"
  ca_file      = "/etc/consul.d/consul-ca.pem"
  cert_file    = "/etc/consul.d/server.pem"
  key_file     = "/etc/consul.d/server-key.pem"
  token        = "{CONSUL-TOKEN}"
  grpc_ca_file = "/etc/consul.d/consul-ca.pem"
  grpc_address = "127.0.0.1:8503"

  server_auto_join = true
  client_auto_join = true
}

telemetry {
  collection_interval        = "5s"
  disable_hostname           = true
  prometheus_metrics         = true
  publish_allocation_metrics = true
  publish_node_metrics       = true
} 
