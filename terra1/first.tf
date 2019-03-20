provider "aws" {
  region = "us-east-1"
}

resource "aws_instance" "instance" {
 ami = "ami-0565af6e282977273"
 instance_type = "t2.micro"
 key_name = "bubba"
  tags = {
    Name = "kiddcorp"
  }
 provisioner "remote-exec"{
  inline=["sudo apt-get -y install python"]
  connection{
      type = "ssh"
      user = "ubuntu"
      private_key = "${file("/home/ubuntu/bubba")}"

    }
 }
}
