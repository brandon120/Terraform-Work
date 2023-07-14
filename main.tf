terraform {
  required_providers {
    google = {
      source  = "hashicorp/google"
      version = "3.69.0"
    }
  }
}

provider "google" {
  #config options
  project = "prj-s-compute-platform-09ba"
  region  = "us-central1"
  zone    = "us-central1-a"
}

resource "google_compute_network" "vpc_network" {
  name = "terraformnetwork"
  mtu = 1460
}

resource "google_compute_subnetwork" "default" {
    name = "customsubnet-brandon"
    ip_cidr_range = "10.0.1.0/24"
    region = "us-central1"
    network = google_compute_network.vpc_network.id
}

resource "google_compute_instance" "terraformnetwork" {
    name = "terraformvm-brandon"
    machine_type = "f1-micro"
    zone = "us-central1-a"
    tags = ["ssh"]

    boot_disk {
        initialize_params {
          image = "debian-cloud/debian-11"
        }
    }
    
    metadata_startup_script = "sudo apt-get update; sudo apt-get install -yq build-essential python3-pip rsync; pip install flask"
    network_interface {
        subnetwork = google_compute_subnetwork.default.id
        
    }
}