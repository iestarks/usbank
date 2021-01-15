
********************************************************************************************
# Beginining OF IAC FOR USBANK Autoscaling, across 2 AZs with  
## MySQL DB Instance, ELB, IGW, NATGW, Bastain Host, 2 Public Subnets, 2 Private Subnets
********************************************************************************************

##############################################################
# Data sources to get VPC Details
##############################################################
data "aws_vpc" "this" {
  filter {
    name = "tag:Name"
    values = ["bankus_east-2-vpc"]
  }
}


##############################################################
# Data sources to get subnets 
##############################################################

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.this.id
   filter {
    name   = "tag:10.60.3.0/24"
    values = ["az2-pri-subnet-3"] # insert value here
  }
}
##############################################################
# Data sources to get security group details
##############################################################

# ######App Servers Security Group
data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id
  name   = var.appsg
}

#########################################################################################
# Modules for SQL Security groups for MySQL
#########################################################################################

module "mysql_security_group" {
  source  = "terraform-aws-modules/security-group/aws//modules/mysql"
 # source  = "git@github.com:iestarks/terraform-aws-security-group.git"
  name = var.mysql_name
  vpc_id = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
}

#########################################################################################
# Modules for ELB Security groups for MySQL
#########################################################################################

module "elb_security_group" {
  source  = "./modules/terraform-aws-security-group/modules/http-80/"
  vpc_id = data.aws_vpc.this.id
  name = var.elbsgname
  ingress_rules = var.ingress_rules 
}


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

   security_groups = module.elb_security_group.this_security_group_name
   subnets = data.aws_subnet_ids.all.ids
   internal   = var.listener
   vpc_id = data.aws_vpc.this.id
   name = var.elbsgname
   ingress_rules =  var.ingress_rules
   #instances = ""


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
  instances = var.instances
  #elb = data.elb_http.this.name
  elb = var.elb_name

}

##################################################################################################################################################################
#Autoscaling Group Creation
##################################################################################################################################################################
module "usbank-autoscaling"{
  source = "git@github.com:iestarks/terraform-aws-autoscaling.git"
}
##################################################################################################################################################################################

********************************************************************************************

# END OF IAC FOR USBANK Autoscaling, across 2 AZs with  
## MySQL DB Instance, ELB, IGW, NATGW, Bastain Host, 2 Public Subnets, 2 Private Subnets

********************************************************************************************
