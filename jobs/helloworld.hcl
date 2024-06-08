job "helloworld" {
  datacenters = ["dc1"]
  type        = "service"

  // constraint {
  //   attribute = "${node.unique.name}"
  //   value     = "client-0"
  // }
  meta {
    my-key = "my-value-1"
  }

  migrate {
    max_parallel     = 1
    health_check     = "checks"
    min_healthy_time = "10s"
    healthy_deadline = "5m"
  }

  group "helloworld" {
    count = 4

    network {
      port "http" {
        to = 8000
      }
    }

    update {
      max_parallel     = 1
      min_healthy_time = "10s"
      healthy_deadline = "1m"
    }

    restart {
      attempts = 1
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    reschedule {
      attempts = 1
      interval = "15m"
      unlimited = false
    }

    task "helloworld" {
      driver = "docker"

      config {
        image = "mnomitch/hello_world_server"
        ports = ["http"]
      }

      env {
        MESSAGE = "Hello World!"
      }
    }

    service {
      name = "helloworld"
      port = "http"

      //check {
      //  name     = "alive"
      //  type     = "http"
      //  path     = "/"
      //  interval = "10s"
      //  timeout  = "2s"
      //}
    }
  }
}
