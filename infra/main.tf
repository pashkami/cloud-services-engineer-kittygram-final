terraform {
  required_providers {
    yandex = {
      source = "yandex-cloud/yandex"
    }
  }
  required_version = ">= 0.13" // версия, совместимая с провайдером версия Terraform

  backend "s3" {
    endpoint                    = "storage.yandexcloud.net"
    bucket                      = "my-kittygram-bucket"
    key                         = "terraform.tfstate"
    region                      = "ru-central1"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
  }
}

provider "yandex" {
  service_account_key_file = var.yc_service_account_key  
  # token     = var.yc_token
  cloud_id  = var.yc_cloud_id
  folder_id = var.yc_folder_id
  zone      = var.yc_zone
}

# Получаем секрет из Lockbox
data "yandex_lockbox_secret" "ssh_key" {
  name = "ssh-private-key"
}

# Настройка сети и машины
resource "yandex_vpc_network" "network-1" {
  name = "kittygram-network"
}

resource "yandex_vpc_subnet" "subnet-1" {
  name           = "kittygram-subnet"
  zone           = var.yc_zone
  network_id     = yandex_vpc_network.network-1.id
  v4_cidr_blocks = ["192.168.10.0/24"]
}

# 2. Группа безопасности
resource "yandex_vpc_security_group" "kittygram_sg" {
  name       = "kittygram-security-group"
  network_id = yandex_vpc_network.network-1.id

  ingress {
    protocol       = "TCP"
    port           = 22
    description    = "SSH access"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    protocol       = "TCP"
    port           = 8000
    description    = "HTTP Gateway service"
    v4_cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    protocol       = "ANY"
    from_port      = 0
    to_port        = 65535
    v4_cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "yandex_compute_disk" "boot-disk-1" {
  name     = "boot-disk-1"
  type     = "network-hdd"
  zone     = var.yc_zone
  size     = "20"
  image_id = "fd80tpcdvop5e9qcosnq"
}

resource "yandex_compute_instance" "vm-1" {
  name        = "kittygram-vm"
  platform_id = "standard-v3"
  zone        = var.yc_zone
  resources {
    cores         = 2
    memory        = 2
    core_fraction = 20
  }

  boot_disk {
    disk_id = yandex_compute_disk.boot-disk-1.id
  }

  network_interface {
    subnet_id          = yandex_vpc_subnet.subnet-1.id
    nat                = true
    security_group_ids = [yandex_vpc_security_group.kittygram_sg.id]
  }

  metadata = {
    user-data = file(var.new_user)
  }
}
