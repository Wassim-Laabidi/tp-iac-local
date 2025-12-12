terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "~> 3.0"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

resource "docker_network" "mon_reseau" {
  name   = "mon_reseau"
  driver = "bridge"
}

resource "docker_image" "postgres_image" {
  name         = "postgres:latest"
  keep_locally = true
}

resource "docker_image" "app_image" {
  name = "web-app:latest"
  build {
    context    = "${path.module}"
    dockerfile = "Dockerfile_app"
  }
}

resource "docker_container" "db_container" {
  name  = "db-postgres"
  image = docker_image.postgres_image.image_id

  ports {
    internal = 5432
    external = 5432
  }

  env = [
    "POSTGRES_USER=${var.db_user}",
    "POSTGRES_PASSWORD=${var.db_password}",
    "POSTGRES_DB=${var.db_name}"
  ]

  networks_advanced {
    name = docker_network.mon_reseau.name
  }
}

resource "docker_container" "app_container" {
  name  = "app-web"
  image = docker_image.app_image.image_id

  depends_on = [
    docker_container.db_container
  ]

  ports {
    internal = 80
    external = var.app_port_external
  }

  networks_advanced {
    name = docker_network.mon_reseau.name
  }
}

