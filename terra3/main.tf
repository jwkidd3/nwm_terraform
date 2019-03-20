provider "aws"{
  region = "us-east-1"
}

variable "zones"{
  default = ["us-east-1c","us-east-1d"]
}

resource "aws_instance" "bubba" {
  count = 2
  availability_zone = "${var.zones[count.index]}"
  ami = "ami-0565af6e282977273"
  instance_type = "t2.micro"
  key_name = "bubba"
  security_groups = ["default"]
  provisioner "remote-exec" {
    inline = ["sudo apt-get -y update", 
              "sudo apt-get -y  install sqlite3",
              "sudo apt-get -y install nginx",
              "sudo service nginx start"]
    connection{
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("/home/ubuntu/bubba")}"

    }
  }
}
output "bubba_ip"{
  value = "${aws_instance.bubba.*.public_ip}"
}
