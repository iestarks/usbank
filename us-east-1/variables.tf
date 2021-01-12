
variable "env" {
  description = "Workspace area of the build"
  type        = string
  default     = "stage"
}

variable "name" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default = "usbank_east-1_"
}

# Autoscaling group
variable "max_size" {
  description = "The maximum size of the auto scale group"
  type        = string
  default = "6"
}

variable "min_size" {
  description = "The minimum size of the auto scale group"
  type        = string
  default = "2"
}

variable "desired_capacity" {
  description = "The number of Amazon EC2 instances that should be running in the group"
  type        = string
  default =  "4"
}

variable "vpc_zone_identifier" {
  description = "A list of subnet IDs to launch resources in"
  type        = list(string)
  default     = ["subnet-00d5e34f04ac9f37e","subnet-00bb62c23a7649dda"]
}


variable "vpc_id" {
  description = "ID of the VPC where to create security group"
  type        = string
  default = "vpc-018de92b069abac0b"
}


variable "azs" {
  description = "A list of availability zones names or ids in the region"
  type        = list(string)
  default     = ["us-east-1a","us-east-1c"]
}

variable "cidr" {
  description = "The CIDR block for the VPC. Default value is a valid CIDR, but not acceptable by AWS and should be overridden"
  type        = string
  default     = "10.60.0.0/16"
}

variable "ingress_cidr_blocks" {
  description = "List of IPv4 CIDR ranges to use on all ingress rules"
  type        = list(string)
  default     = []
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.60.0.0/24"]
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.60.1.0/24","10.60.3.0/24","10.60.5.0/24"]
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = ["10.60.2.0/24","10.60.4.0/24","10.60.6.0/24"]
}
# variable "vpc_zone_identifier" {
#   description = "A list of subnet IDs to launch resources in"
#   type        = list(string)
#   default     = ["subnet-00d5e34f04ac9f37e","subnet-00bb62c23a7649dda"]
# }
variable "security_groups" {
  description = "A list of security group IDs to assign to the launch configuration"
  type        = list(string)
  default     = ["sg-0e5b9c66b637fde20","sg-0a26db02d72db4450"]
}

variable "ingress_with_cidr_blocks" {
  description = "List of ingress rules to create where 'cidr_blocks' is used"
  type        = list(map(string))
  default     = []
}

variable "health_check_type" {
  description = "Controls how health checking is done. Values are - EC2 and ELB"
  type        = string
  default =  "ELB"
}