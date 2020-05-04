provider "google" {
  project = var.project
  region  = var.region
}

data "google_client_config" "default" {
}

// Terraform plugin for creating random ids
resource "random_id" "default" {
  byte_length = 8
}

locals {
  zone                     = var.zone
  key                      = var.relay_key
  secret                   = var.relay_secret
  buckets                  = var.relay_buckets
  agent_instance_type      = var.agent_instance_type
}

// A single Google Cloud Engine instance
resource "google_compute_instance" "relay_agent_vm" {
  name         = "relay-agent-vm-${random_id.default.hex}"
  machine_type = local.agent_instance_type
  zone         = local.zone

  boot_disk {
    initialize_params {
      image = var.machine_image
    }
  }

  metadata_startup_script = <<-EOF
#!/bin/bash -xe
echo "Starting Webhook Relay agent"

sudo docker run --net host -d --name relay-agent -e 'RELAY_KEY=${local.key}' -e 'RELAY_SECRET=${local.secret}' -e 'BUCKETS=${local.buckets}' webhookrelay/webhookrelayd:latest

EOF
  network_interface {
    network = google_compute_network.webhookrelay_network.name

    access_config {
      nat_ip = google_compute_address.agent_ipv4_address.address
    }
  }
 
  allow_stopping_for_update = true
}

resource "google_compute_address" "agent_ipv4_address" {
  name = "relay-agent-ipv4-address-${random_id.default.hex}"
}

resource "google_compute_firewall" "webhookrelay_ssh_firewall" {
  name    = "webhookrelay-ssh-firewall-${random_id.default.hex}"
  network = google_compute_network.webhookrelay_network.name

  allow {
    protocol = "icmp"
  }

  allow {
    protocol = "tcp"
    // Port 22   - Provides ssh access to the relay agent
    ports = ["22"]
  }

  source_ranges = [var.ssh_access_cidrs]
}

resource "google_compute_network" "webhookrelay_network" {
  name = "webhookrelay-network-${random_id.default.hex}"
}