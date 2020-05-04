output "gcloud_ssh" {
  value = join("", ["gcloud beta compute ssh --zone ", local.zone, " " , google_compute_instance.relay_agent_vm.name,  " --project ${var.project}"])
}

output "external_ip_address" {
  value = google_compute_address.agent_ipv4_address.address
}