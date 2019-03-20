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
data "template_file" "dev_hosts" {
  template = "${file("dev_hosts.cfg")}"
  depends_on = [
    "aws_instance.instance"
  ]
  vars {
    api_public = "${aws_instance.instance.public_ip}"
    host = "host01"
  }
}

resource "null_resource" "dev-hosts" {
  triggers {
    template_rendered = "${data.template_file.dev_hosts.rendered}"
  }
  provisioner "local-exec" {
    command = "echo '${data.template_file.dev_hosts.rendered}' > /home/ubuntu/ansible_jk/inventory/hosts"
  }
}
