output "vm_public_ip" {
  description = "Вывод публичного IP виртуальной машины"
  value       = yandex_compute_instance.kittygram-vm.network_interface[0].nat_ip_address
}
