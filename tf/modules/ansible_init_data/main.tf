terraform {
  required_providers {
    ansible = {
      source = "ansible/ansible"
    }
  }
}

variable "is_local" {
  type = bool
}

resource "ansible_playbook" "playbook_local" {

  count = var.is_local ? 1 : 0

  playbook   = "${path.module}/deploy.yml"
  name       = "localhost"
  replayable = false

  extra_vars = {
    ansible_connection : "local"
    ansible_hostname : "localhost"
    data_path : "${var.data_path}"
    image_id : var.image_id
  }
}

resource "ansible_playbook" "playbook" {

  count = var.is_local ? 0 : 1

  playbook   = "${path.module}/deploy.yml"
  name       = var.hostname
  replayable = false

  extra_vars = {
    ansible_user : "root"
    ansible_connection : "ssh"
    # ansible_ssh_extra_args: "-o ForwardAgent=yes"
    ansible_ssh_private_key_file : "~/.ssh/id_rsa.darklab"
    data_path : var.data_path
    image_id : var.image_id
  }
}

variable "hostname" {
  type = string
}

variable "data_path" {
  type = string
}

variable "image_id" {
  type = string
}