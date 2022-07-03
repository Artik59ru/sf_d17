terraform {
  required_providers {
    yandex = {
      source  = "yandex-cloud/yandex"
      version = "0.72.0"
    }
  }
}
provider "yandex" {
  token     = "<token>"
  cloud_id  = "<cloud_id>"
  folder_id = "<folder_id>"
  zone      = "ru-central1-a"
}

resource "yandex_vpc_network" "network" {
  name = "swarm-network"
}

resource "yandex_vpc_subnet" "subnet" {
  name           = "subnet1"
  zone           = "ru-central1-a"
  network_id     = yandex_vpc_network.network.id
  v4_cidr_blocks = ["10.10.10.0/24"]
}

module "swarm_cluster" {
  source        = "./modules/instance"
  vpc_subnet_id = yandex_vpc_subnet.subnet.id
  managers      = 1
  workers       = 2
}
