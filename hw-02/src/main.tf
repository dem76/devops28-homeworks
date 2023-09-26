resource "yandex_vpc_network" "develop" {
  name            = var.vpc_name
}
resource "yandex_vpc_subnet" "develop" {
  name            = var.vpc_name
  zone            = var.default_zone
  network_id      = yandex_vpc_network.develop.id
  v4_cidr_blocks  = var.default_cidr
}

# vm1
data "yandex_compute_image" "ubuntu" {
  family          = var.vm_web_family
}
resource "yandex_compute_instance" "platform_web" {
  name            = local.vm_web_name
  platform_id     = var.vm_web_platform_id
  resources {
    cores         = var.vm_web_resources.vm_web_cores
    memory        = var.vm_web_resources.vm_web_memory
    core_fraction = var.vm_web_resources.vm_web_core_fraction 
  }
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible   = true
  }
  network_interface {
    subnet_id     = yandex_vpc_subnet.develop.id
    nat           = true
  }

  metadata        = local.vms_metadata
}

# vm2
resource "yandex_compute_instance" "platform_db" {
  name            = local.vm_db_name
  platform_id     = var.vm_db_platform_id
  resources {
    cores         = var.vm_db_resources.vm_db_cores
    memory        = var.vm_db_resources.vm_db_memory
    core_fraction = var.vm_db_resources.vm_db_core_fraction
  }
  boot_disk {
    initialize_params {
      image_id    = data.yandex_compute_image.ubuntu.image_id
    }
  }
  scheduling_policy {
    preemptible   = true
  }
  network_interface {
    subnet_id     = yandex_vpc_subnet.develop.id
    nat           = true
  }

  metadata        = local.vms_metadata
}