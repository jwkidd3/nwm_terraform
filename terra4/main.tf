terraform{
  backend "s3"{
   bucket="jkterraform"
   key = "terra/terra4"
   region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws"{
  alias="saeast"
  region="sa-east-1"
}

data "aws_availability_zones" "us-east-zones"{
}

data "aws_availability_zones" "sa-east-zones" {
   provider="aws.saeast"
}

variable "env-name"{
  default = "pre-prod"
}

locals{
  default_front_name="${join("-",list(var.env-name,"frontend"))}"
  default_back_name="${join("-",list(var.env-name,"backend"))}"
}

variable "multi-region"{
  default=true
}

resource "aws_instance" "frontend" {
 tags = {
    Name = "${local.default_front_name}"
  }
 depends_on = ["aws_instance.backend"]
 availability_zone="${data.aws_availability_zones.us-east-zones.names[count.index]}"
 ami = "ami-0565af6e282977273"
 instance_type = "t2.micro"
 key_name = "bubba"
 lifecycle{
    create_before_destroy = true
  }
}
resource "aws_instance" "backend" {
  tags = {
    Name ="${local.default_back_name}"
  }
  availability_zone="${data.aws_availability_zones.sa-east-zones.names[count.index]}"
  count = "${var.multi-region ? 2:0}"
  provider="aws.saeast"
  ami = "ami-05eaf9b21ed6dee3c"
  instance_type = "t2.micro"
  key_name = "bubba"
  timeouts {
    create = "60m"
    delete = "2h"
  }
}
output "frontend_ip" {
  value="${aws_instance.frontend.public_ip}"
}
