output "vm_ip" {
  description = "Вывод публичного IP виртуальной машины"
  value       = yandex_compute_instance.vm-1.network_interface[0].nat_ip_address
  sensitive   = false
}
