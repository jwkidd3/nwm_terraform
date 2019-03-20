terraform{
  backend "s3"{
   bucket="jkterraform"
   key = "terra/state"
   region = "us-east-1"
  }
}

provider "aws" {
  region = "us-east-1"
}

provider "aws"{
  alias="sa-east-1"
  region="sa-east-1"
}

resource "aws_instance" "frontend" {
 depends_on = ["aws_instance.backend"]
 ami = "ami-0565af6e282977273"
 instance_type = "t2.micro"
 key_name = "bubba"
  tags = {
    Name = "table1jk-fe"
  }
  lifecycle{
    create_before_destroy = true
  }
}
resource "aws_instance" "backend" {
  count = 1
  provider="aws.sa-east-1"
  ami = "ami-05eaf9b21ed6dee3c"
  instance_type = "t2.micro"
  key_name = "bubba"
  tags = {
    Name = "table1jk-be"
  }
  timeouts {
    create = "60m"
    delete = "2h"
  }
}

