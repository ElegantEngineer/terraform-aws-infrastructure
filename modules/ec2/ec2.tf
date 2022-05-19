
data "aws_ami" "ubuntu" {
  most_recent = true
  owners      = ["099720109477"]

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-*-${var.ubuntu_version}-amd64-server-*"]
  }
  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }
}

resource "aws_instance" "this" {
  count                  = var.instance_count
  ami                    = var.ami_version == null ? data.aws_ami.ubuntu.id : var.ami_version
  instance_type          = var.instance_type
  availability_zone      = join("", [var.availability_zone, var.az_number])
  # VPC
  subnet_id              = var.subnet_id
  # Security Group
  vpc_security_group_ids = var.vpc_security_group_ids
  # the Public SSH key
  key_name               = var.key_name

  tags = {
    Name = "${var.name}-aws-${var.region}-${count.index + 1}"
  }

  // Dynamically create EBS volumes and attach to EC2 at the time of creation. ebs_block_device variable accepts a list of maps.
  dynamic "ebs_block_device" {
    for_each = var.extra_disk
    content {
      delete_on_termination = lookup(ebs_block_device.value, "delete_on_termination", null)
      device_name           = "/dev/xvdb"
      volume_size           = lookup(ebs_block_device.value, "volume_size", null)
      volume_type           = lookup(ebs_block_device.value, "volume_type", null)
      tags = {
        Name = ebs_block_device.key
      }
    }
  }

  connection {
    user = "ubuntu"
    host = self.public_ip
    agent = true
    timeout = "3m"
  }

  provisioner "remote-exec" {
    inline = [
      "sudo adduser --gecos \"\" --disabled-password ${var.username}",
      "sudo usermod -aG sudo,adm ${var.username}",
      "sudo mkdir /home/${var.username}/.ssh",
      "sudo cp /home/ubuntu/.ssh/authorized_keys /home/${var.username}/.ssh/",
      "sudo chmod 0700 /home/${var.username}/.ssh",
      "sudo chmod 0600 /home/${var.username}/.ssh/authorized_keys",
      "sudo chown -R ${var.username}:${var.username} /home/${var.username}/.ssh",
      "echo '${var.username} ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee /etc/sudoers.d/91-cloud-users >/dev/null",
      "echo '${var.deployuser} ALL=(ALL:ALL) NOPASSWD:ALL' | sudo tee -a /etc/sudoers.d/91-cloud-users >/dev/null",
      "sudo chmod 0600 /etc/sudoers.d/91-cloud-users",
    ]
  }
}

output "public_ip" {
  value = aws_instance.this[*].public_ip
}

output "private_ip" {
  value = aws_instance.this[*].private_ip
}