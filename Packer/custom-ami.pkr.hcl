packer {
  required_plugins {
    amazon = {
      source  = "github.com/hashicorp/amazon"
      version = ">=1.0.0"
    }
  }
}

variable "source_ami" {
  type    = string
  default = "ami-06db4d78cb1d3bbf9" # debian 64
}
variable "source_jar" {
  type    = string
  default = ""
}
variable "ssh_username" {
  type    = string
  default = "admin"
}
variable "aws_region" {
  type    = string
  default = "us-east-1"
}
variable "subnet-id" {
  type    = string
  default = "subnet-085cb97ce72cd55ff"
}
source "amazon-ebs" "custom-ami" {
  region     = var.aws_region
  source_ami = var.source_ami
  ami_name   = "csye6225_${formatdate("YYYY_MM_DD_hh_mm_ss", timestamp())}"

  instance_type = "t2.micro" # Specify the instance type for the temporary instance
  ssh_username  = var.ssh_username
  profile       = "dev"
  ami_users     = ["957845414123"]
  subnet_id     = var.subnet-id

  aws_polling {
    delay_seconds = 120
    max_attempts  = 50
  }

}

build {

  sources = ["source.amazon-ebs.custom-ami"]
  name    = "file-names"
  provisioner "file" {
    source      = "${var.source_jar}"
    destination = "/tmp/CloudAssignment2-0.0.1-SNAPSHOT.jar"
  }
  provisioner "file" {
    source      = "opt/users.csv"
    destination = "/tmp/users.csv"
  }
  provisioner "file" {
    source      = "systemd/webapp.service"
    destination = "/tmp/"

  }

  provisioner "file" {
    source      = "cloudwatch/cloudwatch-config.json"
    destination = "/tmp/"
  }

  provisioner "shell" {
    environment_vars = [
      "DEBIAN_FRONTEND=noninteractive",
      "CHECKPOINT_DISABLE=1"
    ]
    inline = [
      "sudo apt-get update",
      "sudo apt-get upgrade -y",
      "sudo apt-get clean",
      "sudo groupadd csye6225",
      "sudo useradd -s /bin/false -g csye6225 -d /opt/csye6225 -m csye6225",
      "sudo mv /tmp/CloudAssignment2-0.0.1-SNAPSHOT.jar /opt/csye6225/",
      "sudo mv /tmp/users.csv /opt/",
      "sudo mkdir -p /tmp/systemd",
      "sudo mv /tmp/webapp.service /etc/systemd/system/",
      "sudo mkdir -p /var/log/tomcat9/",
      "sudo mv /tmp/cloudwatch-config.json /opt/",
      "sudo apt-get install openjdk-17-jdk -y",
      "sudo apt-get install maven -y"

    ]
  }
  provisioner "shell" {
    script = "Packer/ami-script.sh"
  }

  provisioner "shell" {
    inline = [

      "sudo -u csye6225 touch /opt/csye6225/application.properties",
      "sudo chown csye6225:csye6225 /opt/csye6225/CloudAssignment2-0.0.1-SNAPSHOT.jar",
      "sudo chmod 750 /opt/csye6225/CloudAssignment2-0.0.1-SNAPSHOT.jar",
      "sudo chown csye6225:csye6225 /opt/csye6225/application.properties",
      "sudo chmod 750 /opt/csye6225/application.properties",
      "sudo systemctl daemon-reload",
      "sudo systemctl enable webapp.service",
      "sudo systemctl start webapp.service",
      "sudo systemctl enable amazon-cloudwatch-agent"
    ]
  }



}
