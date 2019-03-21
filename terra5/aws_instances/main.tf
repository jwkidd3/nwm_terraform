data "aws_availability_zones" "available"{}

resource "aws_instance" "instance"{
  tags = "${var.tags}"
  count = "${var.total_instances}"
  ami   = "${var.amis[var.region]}"
  key_name = "devops"
  instance_type = "t2.micro"
  security_groups = ["default"]
  availability_zone="${data.aws_availability_zones.available.names[count.index]}"
  provisioner "remote-exec" {
     inline = "${var.cmds}"
     connection{
       type     = "ssh"
       user     = "ubuntu"
       private_key = "${file("/home/ubuntu/devops")}"
     }
   }
}
