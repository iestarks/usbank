
variable "env" {
  description = "Workspace area of the build"
  type        = string
  default     = "stage"
}

variable "mysql_name" {
  description = "The name of the MySQL Storage Group"
  type        = string
  default    ="mysql-sg"
}


variable "tags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "create_lc" {
  description = "Whether to create launch configuration"
  type        = bool
  default     = true
}

variable "listener" {
  description = "Whether to listen internally or externally at the lb"
  type        = bool
  default     = false
}

variable "elbsgname" {
  description = "ELB Security Group Name"
  type        = string
  default = "http-80-sg"
}


variable "appsg" {
  description = "App server's  security group"
  type        = string
  default     = "usbank-app-sg"
}

variable "elb_name" {
  description = "The name of the ELB"
  type        = string
  default     = "elb-usbank"
}

variable "elb-sg-tag" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default = ""
}


variable "asgname" {
  description = "Creates a unique name beginning with the specified prefix"
  type        = string
  default = "usbank-asg"
}


variable "launch_configuration" {
  description = "The name of the launch configuration to use (if it is created outside of this module)"
  type        = string
  default     = ""
}

# Autoscaling group
variable "max_size" {
  description = "The maximum size of the auto scale group"
  type        = string
  default = "4"
}
variable "image_id" {
  description = "The EC2 image ID to launch"
  type        = string
  default     = "ami-0be2609ba883822ec"
}

variable "wait_for_capacity_timeout" {
  description = "A maximum duration that Terraform should wait for ASG instances to be healthy before timing out. (See also Waiting for Capacity below.) Setting this to '0' causes Terraform to skip all Capacity Waiting behavior."
  type        = string
  default     = "10m"
}


variable "min_size" {
  description = "The minimum size of the auto scale group"
  type        = string
  default = "0"
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
  default     = ["10.60.0.0/16"]
}


variable "ingress_rules" {
    type = list(object({
      from_port   = number
      to_port     = number
      protocol    = string
      cidr_blocks  = string
      description = string
    }))
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
# variable "security_groups" {
#   description = "A list of security group IDs to assign to the launch configuration"
#   type        = list(string)
#   #default     = ["sg-0e5b9c66b637fde20","sg-0a26db02d72db4450"]
# }

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

variable "instance_id" {
  description = "The EC2 instance ID to launch"
  type        = string
  default     = ""
}

variable "health_check" {
  description = "A health check block"
  type        = map(string)
  default = {"target" = "HTTP:80/","interval" = "30","healthy_threshold" = "2","unhealthy_threshold" = "2","timeout" = "5"}
}



variable "subnets" {
  description = "The name of initial lifecycle hook"
  type        = string
  default     = ""
}

variable "instance_port" {
  description = "The instance_port setting"
  type        = string
  default     = "80"
}

variable "number_of_instances" {
  description = "Number of instances to attach to ELB"
  type        = number
  default     = 4
}

variable "instances" {
  description = "instances to attach to ELB"
  type        = list(string)
  default     = []
}


variable "instance_type" {
  description = "The instance type"
  type        = string
  default     = "t2.micro"
}

variable "instance_protocol" {
  description = "The instance protocol setting"
  type        = string
  default     = "HTTP"
}

variable "lb_port" {
  description = "The load balancer port setting"
  type        = string
  default     = "80"
}

variable "lb_protocol" {
  description = "The load balancer port setting"
  type        = string
  default     = "80"
}


variable "interval" {
  description = "The load balancer port setting"
  type        = number
  default     = 30
}

variable "healthy_threshold" {
  description = "The load balancer port setting"
  type        = number
  default     = 2
}

variable "unhealthy_threshold" {
  description = "The unhealthy_thresholdsetting"
  type        = number
  default     = 2
}
variable "target" {
  description = "target protocol"
  type        = string
  default     = "HTTP:80/"
}



variable "timeout" {
  description = "The lb timeout setting"
  type        = number
  default     = 5
}


variable "owner" {
  description = "The owner"
  type        = string
  default     = "user"
}