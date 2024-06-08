job "hello" {
  datacenters = ["dc1"]
  type = "batch"

  periodic {
    cron             = "*/1 * * * * *"
    prohibit_overlap = true
    time_zone = "Asia/Tokyo"
  }

  group "hello" {
    task "echo" {
      driver = "raw_exec"
      config {
        command = "/bin/bash"
        args    = ["-c", "echo Hi, Hello! && sleep 10" ]
      }
    }
  }
}
