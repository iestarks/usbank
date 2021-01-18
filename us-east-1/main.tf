
#********************************************************************************************
# Beginining OF IAC FOR USBANK Autoscaling, across 2 AZs with  
## MySQL DB Instance, ELB, IGW, NATGW, Bastain Host, 2 Public Subnets, 2 Private Subnets
#********************************************************************************************

# module "terraform-aws-vpc" {
# source = "./modules/terraform-aws-vpc/"
# ingress_rules = var.ingress_rules
# }


##############################################################
# Data sources to get VPC Details
##############################################################
data "aws_vpc" "usbank_vpc" {
  filter {
    name = "tag:Name"
    values = [var.vpcname]
  }
}

##############################################################
# Data sources to get subnets 
##############################################################

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.usbank_vpc.id
    #vpc_id = module.terraform-aws-vpc.name
   filter {
    name   = "tag:10.60.3.0/24"
    values = ["az2-pri-subnet-3"] # insert value here
  }
}
##############################################################
# Data sources to get security group details
##############################################################

# ######App Servers Security Group
# data "aws_security_group" "this" {
#   vpc_id = data.aws_vpc.usbank_vpc.id
#       #vpc_id = module.terraform-aws-vpc.name
#   name   = var.elbsgname
#   #  filter {
#   #   name   = "tag:Name"
#   #   values = ["http-80-sg"] # insert value here
#   # }
# }

# data "aws_security_group" "this" {
#   vpc_id = data.aws_vpc.usbank_vpc.id
#   name   = var.elbsgname
# }

#########################################################################################
# Modules for SQL Security groups for MySQL
#########################################################################################

# module "mysql_security_group" {
#   source  = "./modules/terraform-aws-security-group/modules/mysql/"
#  # source  = "git@github.com:iestarks/terraform-aws-security-group.git"
#   name = var.mysql_name
#  vpc_id = data.aws_vpc.usbank_vpc.id
#    #  vpc_id = module.terraform-aws-vpc.name
#   #ingress_cidr_blocks = var.ingress_cidr_blocks
#   ingress_rules = var.ingress_rules

# }

#########################################################################################
# Modules for ELB Security groups for MySQL
#########################################################################################

# module "terraform-aws-security-group" {
#   source  = "./modules/terraform-aws-security-group/modules/http-80/"
#  vpc_id = data.aws_vpc.usbank_vpc.id
#     # vpc_id = module.terraform-aws-vpc.name
#   name = var.elbsgname
#   ingress_rules = var.ingress_rules 
# }


########################################################################################################################################
##Give Bucket Permission and allow access for the ELB
##################################################################################################################################################

data "aws_elb_service_account" "main" {}

resource "aws_s3_bucket" "elb_logs" {
  bucket = "usbank-elb-bucket"
  acl    = "private"

  policy = <<POLICY
{
  "Id": "Policy",
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": [
        "s3:PutObject"
      ],
      "Effect": "Allow",
      "Resource": "arn:aws:s3:::usbank-elb-bucket/AWSLogs/*",
      "Principal": {
        "AWS": [
          "${data.aws_elb_service_account.main.arn}"
        ]
      }
    }
  ]
}
POLICY
}




################################################################
#ElB creation module
######################################################################


module "elb_http" {
  source = "./modules/terraform-aws-elb/modules/elb/"

   #security_groups = data.aws_security_group.this.*.id
   security_groups =  data.aws_vpc.usbank_vpc.*.id
   subnets = data.aws_subnet_ids.all.ids
   internal   = var.listener
   vpc_id = data.aws_vpc.usbank_vpc.id
      # vpc_id = module.terraform-aws-vpc.name
   name = var.elbsgname
   ingress_rules =  var.elb_ingress_rules



listener = [
    {
      instance_port     = "80"
      instance_protocol = "HTTP"
      lb_port           = "80"
      lb_protocol       = "HTTP"
    },
    {
      instance_port     = "8080"
      instance_protocol = "http"
      lb_port           = "8080"
      lb_protocol       = "http"
      #ssl_certificate_id = "arn:aws:acm:eu-west-1:235367859451:certificate/6c270328-2cd5-4b2d-8dfd-ae8d0004ad31"
    },
  ]



   health_check = {

    healthy_threshold   = lookup(var.health_check, "healthy_threshold")
    unhealthy_threshold = lookup(var.health_check, "unhealthy_threshold")
    target              = lookup(var.health_check, "target")
    interval            = lookup(var.health_check, "interval")
    timeout             = lookup(var.health_check, "timeout")
  }

  access_logs = {
    bucket = "usbank-bucket"
     interval      = 60
  }
}

module "elb_attachment"{
  source = "./modules/terraform-aws-elb/modules/elb_attachment/"
  number_of_instances = var.number_of_instances
  #instances = element(var.instances, count.index)
  instances = ["i-04e66754807605bd3","i-04e66754807605bd3"]

}

##################################################################################################################################################################
#Autoscaling Group Creation
##################################################################################################################################################################
module "usbank-autoscaling"{
  source = "./modules/terraform-aws-autoscaling/examples/asg_elb/"
  
}


#################################################################################################################################################################
#MySQL DB Creation
##################################################################################################################################################################


module "db" {
source = "./modules/terraform-aws-rds/"
engine_version = var.engine_version
backup_window = var.backup_window
username = var.username
port =  var.port
password =  var.password
instance_class = var.instance_class 
engine =  var.engine 
maintenance_window = var.maintenance_window
identifier =var.identifier
vpc_security_group_ids = [data.aws_vpc.usbank_vpc.id]
allocated_storage = var.allocated_storage
}


##################################################################################################################################################################################

#********************************************************************************************

# END OF IAC FOR USBANK Autoscaling, across 2 AZs with  
## MySQL DB Instance, ELB, IGW, NATGW, Bastain Host, 2 Public Subnets, 2 Private Subnets

#********************************************************************************************
