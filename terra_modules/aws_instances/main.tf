data "aws_availability_zones" "available"{}

resource "aws_key_pair" "thekey" {
  key_name   = "bubba"
  public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDLj5HXh/7D6TPaa1NMRF8mQAT0OZyAnzkfSxhtiAeY2aJUghSyMPEDKotFGjHpsm4MGjjuHW0YdkfLDGcjMqOnm/6Jp4Nnh/3gmu/QVRAHcIV6t13rCtU3xMNK+YUi8r04JsGPKEmuOWHVGTHgdQn96YY4VoLZxRsfGDAAkjl7A5e6JjiqhT3umy+sT1uhVVQWRepIQGuWfthNQQDWlVtAC09r8hep7uP8L/7jVCP/wK2UFT9YINT7sEWfI5MLYyCMUPEHZwDQ3ZHUEGCXc/UoT28glpVmZeT3hqsZfDBC5B5hQUCYIxIVXcAnlVf6Td480QIe9JVFgHrz2oRljjhP ubuntu@ip-172-31-3-97"
}

resource "aws_instance" "instance"{
  count = "${var.total_instances}"
  ami   = "${var.amis[var.region]}"
  key_name = "bubba"
  instance_type = "t3.micro"
  security_groups = ["default"]
  availability_zone="${data.aws_availability_zones.available.names[count.index]}"
  provisioner "remote-exec" {
     inline = "${var.cmds}"
     connection{
       host = self.public_ip
       type     = "ssh"
       user     = "ubuntu"
       private_key = "${file("/home/ubuntu/environment/terraform_fundamentals/exercises/bubba")}"
     }
   }
   depends_on=[aws_key_pair.thekey]
}
