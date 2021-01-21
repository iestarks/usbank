
#********************************************************************************************
# Beginining OF IAC FOR USBANK Autoscaling, across 2 AZs with  
## MySQL DB Instance, ELB, IGW, NATGW, Bastain Host, 2 Public Subnets, 2 Private Subnets
#********************************************************************************************

locals{
    subnet_ids_string = join(",", data.aws_subnet_ids.database.ids)
  subnet_ids_list = split(",", local.subnet_ids_string)

}
##############################################################
# Data sources to get VPC Details
##############################################################
data "aws_vpc" "usbank_vpc" {

  filter {
    name = "tag:Name"
    values = [var.vpcname]
  }
}

data "aws_subnet_ids" "database" {
  vpc_id = data.aws_vpc.usbank_vpc.id
 tags = {
    Name = "bankus_east-1-vpc-public-*"
 }

  # tags = {
  # Name = "bankus_east-1-vpc-db-us-east-1a",
  # Name = "bankus_east-1-vpc-db-us-east-1c",  # insert value here

}

data "aws_subnet" "database" {
  vpc_id = data.aws_vpc.usbank_vpc.id
  count = length(data.aws_subnet_ids.database.ids)
  id    = local.subnet_ids_list[count.index]
}

data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.usbank_vpc.id
  #  filter {
  #   name   = "tag:Name"
     #values = ["bankus_east-1-vpc-public-us-east-1a"] # insert value here
  tags = {
  Name = "usbank-appserv"
  # insert value here
  }
}

########################################################################################################################################
##User Data for Bastian Host
##################################################################################################################################################

locals {

    userdata = <<-USERDATA
    #!/bin/bash
    cat <<"__EOF__" > /home/ec2-user/.ssh/config
    Host *
      StrictHostKeyChecking no
    __EOF__
    chmod 600 /home/ec2-user/.ssh/config
    chown ec2-user:ec2-user /home/ec2-user/.ssh/config
  USERDATA
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
#################################################################################################################################################################
#Auto Scaling Group Creation
##################################################################################################################################################################


#####################################################################################
####  Build the Mysql Security Group
###
#####################################################################################
# module "mysql_security_group" {
#   source  = "./modules/terraform-aws-security-group/modules/mysql/"
#   vpc_id = data.aws_vpc.usbank_vpc.id
#   name = var.dbname
#  # ingress_rules = var.mysql_ingress_rules
# }
#####################################################################################
####  Build the App Server Security Group
###
#####################################################################################

# module "app_security_group" {
#   source  = "./modules/terraform-aws-security-group/modules/https-443/"
#   name = var.appname
#   vpc_id = data.aws_vpc.usbank_vpc.id
#  # ingress_rules = var.appserv_ingress_rules
# }


# module "elb_security_group" {
#   source  = "./modules/terraform-aws-security-group/modules/http-80/"
#   vpc_id = data.aws_vpc.usbank_vpc.id
#   name = var.elbsgname
#  # ingress_rules = var.appserv_ingress_rules
# }


################################################################
#AlB and Auto Scaling Group creation module
######################################################################

module "usbank_alb" {
  source = "./modules/terraform-aws-alb/"
}

module "usbank-asg"{
  source = "./modules/terraform-aws-autoscaling/"
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
vpc_security_group_ids = [data.aws_security_group.this.id]
allocated_storage = var.allocated_storage
major_engine_version = var.major_engine_version
subnet_ids = [data.aws_subnet_ids.database.id]
}


##################################################################################################################################################################################

#********************************************************************************************

# END OF IAC FOR USBANK Autoscaling, across 2 AZs with  
## MySQL DB Instance, ELB, IGW, NATGW, Bastain Host, 2 Public Subnets, 2 Private Subnets

#********************************************************************************************