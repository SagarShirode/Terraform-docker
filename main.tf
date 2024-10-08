terraform {
        required_providers {
        docker = {
        source = "kreuzwerker/docker"
        version = "~> 3.0.2"
}
}
}


provider "docker" {}

resource "docker_network" "wp_network" {
	name = "wp_network"
}

resource "docker_container" "wp_mysql" {
	name = "wp_mysql"
	image = "mysql:8.0"
	restart = "always"

	env = [
		"MYSQL_ROOT_PASSWORD=Your_password",
	        "MYSQL_DATABASE=wordpress",
  	        "MYSQL_USER=wp_user",
   	        "MYSQL_PASSWORD=Your_password"
	     ]
	networks_advanced {
	name = docker_network.wp_network.name
}
}


resource "docker_container" "wordpress" {
  name  = "wordpress"
  image = "wordpress:latest"
  restart = "always"

  env = [
    "WORDPRESS_DB_HOST=${docker_container.wp_mysql.name}:3306",
    "WORDPRESS_DB_NAME=wordpress",
    "WORDPRESS_DB_USER=wp_user",
    "WORDPRESS_DB_PASSWORD=Sagar@8624"
  ]

  ports {
    internal = 80
    external = 8080
  }

  networks_advanced {
    name = docker_network.wp_network.name
  }
}

