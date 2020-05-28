provider "google" {
  credentials = file(var.credentials_file)

  project = var.project
  region  = var.region
  zone    = var.zone
}

# Comment out
#resource "google_compute_network" "vpc_network" {
#  name = "terraform-jsp-network"
#}

resource "google_compute_instance" "vm_instance" {
  name         = "terraform-jsp-instance"
  machine_type = var.machine_types[var.environment]
  tags         = ["web", "dev"]

  provisioner "local-exec" {
    command  = "echo ${google_compute_instance.vm_instance.name}: ${google_compute_instance.vm_instance.network_interface[0].access_config[0].nat_ip} >> ip_address.txt"
  }

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  
  network_interface {
   # Replace this line :
   # network = google_compute_network.vpc_network.name
   # with these two:
    network = module.network.network_name
    subnetwork = module.network.subnets_names[0]
    access_config {
      nat_ip  = google_compute_address.vm_static_ip.address
    }
  }
}

resource "google_compute_address" "vm_static_ip" {
  name  = "tf-jsp-static-ip"
}

resource "google_storage_bucket" "example_bucket" {
  name  = "tf-example-bucket-jsp-20200313"
  location = "ASIA"

  website {
    main_page_suffix = "index.html"
    not_found_page   = "404.html"
  }
}

resource "google_compute_instance" "another_instance" {
  depends_on = [google_storage_bucket.example_bucket]
  
  name         = "tf-instance-2"
  machine_type = "f1-micro"

  boot_disk {
    initialize_params {
      image = "cos-cloud/cos-stable"
    }
  }
  
  network_interface {
    network = module.network.network_name
    subnetwork = module.network.subnets_names[1]
    access_config {
    }
  }
}

module "network" {
 source = "terraform-google-modules/network/google"
 version = "1.1.0"

 network_name = "terrform-jsp-vpc-network"
 project_id = var.project

 subnets = [
  {
    subnet_name   = "subnet-01"
    subnet_ip     = var.cidrs[0]
    subnet_region = var.region
  },
  {
    subnet_name   = "subnet-02"
    subnet_ip     = var.cidrs[1]
    subnet_region = var.region

    subnet_private_access = "true"
  },
 ]
 
 secondary_ranges = {
    subnet-01 = []
    subnet-02 = []
 }
}

terraform {
  backend "remote" {
    hostname = "tfe_host_name"
    organization = "hc-tfe-jsp-demo"
    token = "TFE_API_TOKEN"
    
    workspaces {
    name = "kr-gcp-remotestate-demo" 
    }
  }
}
