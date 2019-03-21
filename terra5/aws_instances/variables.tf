variable "amis"{
  type="map"
  default = {
    us-east-1 = "ami-0565af6e282977273"
    sa-east-1 = "ami-05eaf9b21ed6dee3c"
  }
}

variable "tags"{type="map"}

variable "region"{
  default = "us-east-1"
}

variable "total_instances" {
  default=1
}

variable "cmds"{
  type    = "list"
  default = ["sudo apt -y install python"]
}
