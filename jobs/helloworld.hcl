job "helloworld" {
  datacenters = ["dc1"]
  type        = "service"

  group "helloworld" {
    count = 1

    network {
      port "http" {
        static = 8000
        to = 8000
      }
    }

    update {
      max_parallel     = 1
      min_healthy_time = "30s"
      healthy_deadline = "5m"
    }

    restart {
      attempts = 2
      interval = "30m"
      delay = "15s"
      mode = "fail"
    }

    task "helloworld" {
      driver = "docker"

      config {
        image = "mnomitch/hello_world_server"
        ports = ["http"]
        // logging = {
        //   driver = "journald"
        //   options = [
        //     {
        //       "tag" = "hello_world"
        //     }
        //   ]
        // }
      }

      env {
        MESSAGE = "Hello World!"
      }
    }

    service {
      name = "helloworld"
      port = "http"

      check {
        name     = "alive"
        type     = "http"
        path     = "/"
        interval = "10s"
        timeout  = "2s"
      }
    }
  }
}
