job "nyan" {
  type = "service"

  group "servers" {
    count = 3

    task "frontend" {
      driver = "docker"

      config {
        image = "daviey/nyan-cat-web"
      }

      service {
        port = "http"
      }
    }
  }
}
