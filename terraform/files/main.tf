terraform {
  required_providers {
    ansible = {
      source  = "ansible/ansible"
    }
  }
  backend "http" {
  }
}

variable "host_name" {
  type = string
}

variable "host_ip" {
  type = string
}

variable "host_user" {
  type = string
}

resource "ansible_host" "my_ec2" {
  name   = var.host_name
  groups = ["fedora"]
  variables = {
    ansible_user  = var.host_user
    ansible_host  = var.host_ip
  }
}
