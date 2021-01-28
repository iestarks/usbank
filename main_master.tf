
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


#data "aws_lb_target_group" "test" {}

# #################################################################################################################################################################
#AutoScaling Creation
##################################################################################################################################################################


module "usbank-asg"{
  source = "./modules/terraform-aws-autoscaling/" 
}

#################################################################################################################################################################
#Bastian Host Creation
##################################################################################################################################################################

module "usbank-bastian"{
  source = "./modules/terraform-aws-bastion/"
}
#################################################################################################################################################################
#MySQL DB Creation
##################################################################################################################################################################


module "db" {
source = "./modules/terraform-aws-rds/"
# engine_version = var.engine_version
# backup_window = var.backup_window
# username = var.username
# port =  var.port
# password =  var.password
# instance_class = var.instance_class 
# engine =  var.engine 
# maintenance_window = var.maintenance_window
# identifier =var.identifier
# vpc_security_group_ids = [data.aws_security_group.this.id]
# allocated_storage = var.allocated_storage
# major_engine_version = var.major_engine_version
# subnet_ids = [data.aws_subnet_ids.database.id]
}


##################################################################################################################################################################################

#********************************************************************************************

# END OF IAC FOR USBANK Autoscaling, across 2 AZs with  
## MySQL DB Instance, ELB, IGW, NATGW, Bastain Host, 2 Public Subnets, 2 Private Subnets

#********************************************************************************************