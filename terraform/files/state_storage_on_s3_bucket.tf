terraform {
    required_providers {
        ansible = {
        source  = "ansible/ansible"
        }
    }
    backend "s3" {
    }
}

resource "ansible_host" "my_localhost" {
  name   = "localhost"
  groups = ["fedora"]
  variables = {
    ansible_user  = "fedora"
    ansible_host  = "127.0.0.1"
  }
}