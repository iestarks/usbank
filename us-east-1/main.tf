##############################################################
# Data sources to get security group details
##############################################################




# module "vpc" {
#   source = "../modules/terraform-aws-vpc/"

#   name = "bankus_east-1-vpc"
#   cidr = var.cidr

#   azs             = var.azs
#   private_subnets = var.private_subnets
#   public_subnets  = var.public_subnets

#   enable_nat_gateway = true
#   enable_vpn_gateway = true

#   tags = {
#     Terraform = "true"
#     Environment = "stage"
#   }
# }


###########################
# Security groups for MySQL
###########################
module "mysql_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/mysql"
  name = var.name
  vpc_id = var.vpc_id
}

module "usbank_autoscaling" {
  source  = "../modules/terraform-aws-autoscaling"
}

