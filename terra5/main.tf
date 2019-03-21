module "frontend"{
  source = "./aws_instances"
  tags={lb=""}
}

module "backend"{
  source = "./aws_instances"
  region = "sa-east-1"
  total_instances=2
  tags={web=""}
}

output "front_end_ips"{
  value="${module.frontend.ips}"
}

output "back_end_ips"{
  value="${module.backend.ips}"
}
