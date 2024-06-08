job "nginx" {
  datacenters = ["dc1"]

  group "cache-lb" {
    count = 1

    network {
      port "lb" {
        to = 6379
      }
    }

    service {
      name         = "redis-lb"
      port         = "lb"
      address_mode = "host"

      check {
        type     = "tcp"
        port     = "lb"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "nginx" {
      driver = "docker"

      config {
        image = "nginx"
        ports = ["lb"]
        volumes = [
          "local/nginx.conf:/etc/nginx/nginx.conf",
          "local/nginx:/etc/nginx/conf.d"
        ]
      }

      template {
        data        = <<EOF
user  nginx;
worker_processes  1;
error_log  /var/log/nginx/error.log warn;
pid        /var/run/nginx.pid;
events {
    worker_connections  1024;
}
include /etc/nginx/conf.d/*.conf;
EOF
        destination = "local/nginx.conf"
      }

      # This template creates a TCP proxy to Redis.
      template {
        data          = <<EOF
stream {
  server {
    listen 6379;
    proxy_pass backend;
  }
  upstream backend {
  {{ range service "redis" }}
    server {{ .Address }}:{{ .Port }};
  {{ else }}server 127.0.0.1:65535; # force a 502
  {{ end }}
  }
}
EOF
        destination   = "local/nginx/nginx.conf"
        change_mode   = "signal"
        change_signal = "SIGHUP"
      }

      template {
        data          = <<EOF
hellworld
EOF
        destination   = "local/nginx/test.txt"
        change_mode   = "restart"
      }

      resources {
        cpu    = 50
        memory = 10
      }
    }
  }

  group "cache" {
    count = 3

    network {
      port "db" {
        to = 6379
      }
    }

    service {
      name         = "redis"
      port         = "db"
      address_mode = "host"

      check {
        type     = "tcp"
        port     = "db"
        interval = "10s"
        timeout  = "2s"
      }
    }

    task "redis" {
      driver = "docker"

      config {
        image = "redis:3.2"
        ports = ["db"]
      }

      resources {
        cpu    = 500
        memory = 256
      }
    }
  }
}
