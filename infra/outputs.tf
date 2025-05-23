output "vm_ip" {
  description = "Public IP address of the VM"
  value       = try(yandex_compute_instance.vm-1.network_interface[0].nat_ip_address, "")
  sensitive   = false
}
