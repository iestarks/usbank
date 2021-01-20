
output "vpc_id" {
  description = "The ID of the VPC"
  value = data.aws_vpc.usbank_vpc.id
}

# output "this_autoscaling_group_id" {
#   description = "The autoscaling group id"
#   value       = module.usbank-autoscaling.this_autoscaling_group_id
# }


# output "subnet_cidr_blocks" {
#   value = [for s in data.aws_subnet.example : s.cidr_block]
# }


# output "this_security_group_id" {
#   description = "The ID of the security group"
#   value       = module.elb_security_group.this_security_group_id
# }

#concat(module.elb_security_group.*.this_security_group_id,
  #module.elb_security_group.this_name_prefix.*.this_security_group_id,

output "this_security_group_id" {
  description = "The ID of the security group"
  value = data.aws_security_group.this.id
}



#  output "this_elb_name" {
#    description = "The name of the ELB"
#   # value       = concat(module.elb_http.aws_elb.this.*.name, [""])[0]
#      value = module.elb_http.aws_elb.this[0]
#  }

# output "vpc_id" {
#   description = "The ID of the VPC"
#   value       = concat(aws_vpc.this.*.id, [""])[0]
# }

# output "vpc_arn" {
#   description = "The ARN of the VPC"
#   value       = concat(aws_vpc.this.*.arn, [""])[0]
# }

# output "vpc_cidr_block" {
#   description = "The CIDR block of the VPC"
#   value       = concat(aws_vpc.this.*.cidr_block, [""])[0]
# }


# output "private_subnets" {
#   description = "List of IDs of private subnets"
#   value       = aws_subnet.private.*.id
# }

# output "private_subnets_cidr_blocks" {
#   description = "List of cidr_blocks of private subnets"
#   value       = aws_subnet.private.*.cidr_block
# }


# output "public_subnets" {
#   description = "List of IDs of public subnets"
#   value       = aws_subnet.public.*.id
# }



# output "public_subnets_cidr_blocks" {
#   description = "List of cidr_blocks of public subnets"
#   value       = aws_subnet.public.*.cidr_block
# }

# output "database_subnets" {
#   description = "List of IDs of database subnets"
#   value       = aws_subnet.database.*.id
# }

# output "database_subnets_cidr_blocks" {
#   description = "List of cidr_blocks of database subnets"
#   value       = module.aws_vpc.aws_subnet_ids.all.database.*.cidr_block
# }

#########################################################################################
###SEcurity Group Outputs
######################################################################################


# output "this_security_group_id" {
#   description = "The ID of the security group"
#   value       = module.sg.this_security_group_id
# }


# output "this_security_group_owner_id" {
#   description = "The owner ID"
#   value       = module.sg.this_security_group_owner_id
# }

# output "this_security_group_name" {
#   description = "The name of the security group"
#   value       = module.sg.this_security_group_name
# }

# output "this_security_group_description" {
#   description = "The description of the security group"
#   value       = module.sg.this_security_group_description
# }

 output "aws_subnet" {
  description = "The description of the security group"
  value       = data.aws_subnet.database.*.id
}
