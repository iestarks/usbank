
# variable "vpc_id" {
#   description = "Workspace area of the build"
#   type        = string
# }
variable "private_subnet_tags" {
  description = "Additional tags for the private subnets"
  type        = list(string)
  default = ["bankus_east-1-vpc-private-us-east-1a","bankus_east-1-vpc-private-us-east-1c"]
}

variable "private_subnet_suffix" {
  description = "Suffix to append to private subnets name"
  type        = string
  default     = "private"
}

variable "private_subnets" {
  description = "A list of private subnets inside the VPC"
  type        = list(string)
  default     = ["10.60.1.0/24","10.60.3.0/24"]
}

variable "database_subnets" {
  description = "A list of database subnets"
  type        = list(string)
  default     = ["10.60.2.0/24","10.60.4.0/24"]
}


variable "appname" {
  description = "App server name to be used on all the resources as identifier"
  type        = string
  default     = "usbank-appserv"
}



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

variable "vpcname" {
  description = "Name to be used on all the resources as identifier"
  type        = string
  default     = "bankus_east-1-vpc"
}


variable "sgtags" {
  description = "A mapping of tags to assign to security group"
  type        = map(string)
  default     = {}
}

variable "create_lc" {
  description = "Whether to create launch configuration"
  type        = bool
  default     = true
}


variable "listeners" {
  description = "A health check block"
  type        = list(object({
  default = {"instance_port" = "80","instance_protocol" = "HTTP","lb_portb" = "80","lb_protocol" = "HTTP"}
  }))
}



variable "elbname" {
  description = "ELB  Name"
  type        = string
  default = "http-80-elb"
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

# variable "elb_name" {
#   description = "The name of the ELB"
#   type        = string
#   default     = "elb-usbank"
# }

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
  default     = []
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


variable "mysql_ingress_rules" {
  description = "mysql ingress rules"
  type        = list(map(string))

  default = [
    {
      rule_number = 30
      rule_action = "allow"
      from_port   = 3306
      to_port     = 3306
      protocol    = "tcp"
      cidr_blocks  = "10.60.1.0/24"
      description = "MySQL ingress rules"
    },
  ]
}


variable "elb_ingress_rules" {
  description = "ELB ingress rules"
  type        = list(map(string))

  default = [
    {
      rule_number = 80
      rule_action = "allow"
      from_port   = 80
      to_port     = 80
      protocol    = "tcp"
      cidr_blocks  = "10.60.0.0/16"
     description = "ELB ingress rules"
    },
  ]
}

variable "public_subnets" {
  description = "A list of public subnets inside the VPC"
  type        = list(string)
  default     = ["10.60.0.0/24"]
}

# variable "private_subnets" {
#   description = "A list of private subnets inside the VPC"
#   type        = list(string)
#   default     = ["10.60.1.0/24","10.60.3.0/24","10.60.5.0/24"]
# }

# variable "database_subnets" {
#   description = "A list of database subnets"
#   type        = list(string)
#   default     = ["10.60.2.0/24","10.60.4.0/24","10.60.6.0/24"]
# }
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




variable "identifier" {
  description = "The name of the RDS instance, if omitted, Terraform will assign a random, unique identifier"
  type        = string
  default = "mysql-db"
}

variable "allocated_storage" {
  description = "The allocated storage in gigabytes"
  type        = string
  default  = "5"
}

variable "storage_type" {
  description = "One of 'standard' (magnetic), 'gp2' (general purpose SSD), or 'io1' (provisioned IOPS SSD). The default is 'io1' if iops is specified, 'standard' if not. Note that this behaviour is different from the AWS web console, where the default is 'gp2'."
  type        = string
  default     = "gp2"
}

variable "storage_encrypted" {
  description = "Specifies whether the DB instance is encrypted"
  type        = bool
  default     = false
}

variable "kms_key_id" {
  description = "The ARN for the KMS encryption key. If creating an encrypted replica, set this to the destination KMS ARN. If storage_encrypted is set to true and kms_key_id is not specified the default KMS key created in your account will be used"
  type        = string
  default     = ""
}

variable "replicate_source_db" {
  description = "Specifies that this resource is a Replicate database, and to use this value as the source database. This correlates to the identifier of another Amazon RDS Database to replicate."
  type        = string
  default     = ""
}

variable "snapshot_identifier" {
  description = "Specifies whether or not to create this database from a snapshot. This correlates to the snapshot ID you'd find in the RDS console, e.g: rds:production-2015-06-26-06-05."
  type        = string
  default     = ""
}

variable "license_model" {
  description = "License model information for this DB instance. Optional, but required for some DB engines, i.e. Oracle SE1"
  type        = string
  default     = ""
}

variable "iam_database_authentication_enabled" {
  description = "Specifies whether or not the mappings of AWS Identity and Access Management (IAM) accounts to database accounts are enabled"
  type        = bool
  default     = false
}

variable "domain" {
  description = "The ID of the Directory Service Active Directory domain to create the instance in"
  type        = string
  default     = ""
}

variable "domain_iam_role_name" {
  description = "(Required if domain is provided) The name of the IAM role to be used when making API calls to the Directory Service"
  type        = string
  default     = ""
}

variable "engine" {
  description = "The database engine to use"
  type        = string
  default = "mysql"
}

variable "engine_version" {
  description = "The engine version to use"
  type        = string
  default  = "5.7.19"
}

variable "final_snapshot_identifier" {
  description = "The name of your final DB snapshot when this DB instance is deleted."
  type        = string
  default     = null
}

variable "instance_class" {
  description = "The instance type of the RDS instance"
  type        = string
  default = "db.t2.large"
}

variable "dbname" {
  description = "The DB name to create. If omitted, no database is created initially"
  type        = string
  default     = "usbank_mysql"
}

variable "username" {
  description = "Username for the master DB user"
  type        = string
  default = "mysqldb"
}

variable "password" {
  description = "Password for the master DB user. Note that this may show up in logs, and it will be stored in the state file"
  type        = string
  default = "YourPwdShouldBeLongAndSecure!"
}

variable "port" {
  description = "The port on which the DB accepts connections"
  type        = string
  default = "3306"
}

variable "vpc_security_group_ids" {
  description = "List of VPC security groups to associate"
  type        = list(string)
  default     = []
}

variable "db_subnet_group_name" {
  description = "Name of DB subnet group. DB instance will be created in the VPC associated with the DB subnet group. If unspecified, will be created in the default VPC"
  type        = string
  default     = ""
}

variable "parameter_group_description" {
  description = "Description of the DB parameter group to create"
  type        = string
  default     = "mysql5.7"
}




variable "parameter_group_name" {
  description = "Name of the DB parameter group to associate or create"
  type        = string
  default     = "mysql5.7"
}

variable "option_group_name" {
  description = "Name of the DB option group to associate"
  type        = string
  default     = ""
}

variable "availability_zone" {
  description = "The Availability Zone of the RDS instance"
  type        = string
  default     = ""
}

variable "multi_az" {
  description = "Specifies if the RDS instance is multi-AZ"
  type        = bool
  default     = false
}

variable "iops" {
  description = "The amount of provisioned IOPS. Setting this implies a storage_type of 'io1'"
  type        = number
  default     = 0
}

variable "publicly_accessible" {
  description = "Bool to control if instance is publicly accessible"
  type        = bool
  default     = false
}

variable "monitoring_interval" {
  description = "The interval, in seconds, between points when Enhanced Monitoring metrics are collected for the DB instance. To disable collecting Enhanced Monitoring metrics, specify 0. The default is 0. Valid Values: 0, 1, 5, 10, 15, 30, 60."
  type        = number
  default     = 0
}

variable "monitoring_role_arn" {
  description = "The ARN for the IAM role that permits RDS to send enhanced monitoring metrics to CloudWatch Logs. Must be specified if monitoring_interval is non-zero."
  type        = string
  default     = ""
}

variable "monitoring_role_name" {
  description = "Name of the IAM role which will be created when create_monitoring_role is enabled."
  type        = string
  default     = "rds-monitoring-role"
}

variable "create_monitoring_role" {
  description = "Create IAM role with a defined name that permits RDS to send enhanced monitoring metrics to CloudWatch Logs."
  type        = bool
  default     = false
}

variable "allow_major_version_upgrade" {
  description = "Indicates that major version upgrades are allowed. Changing this parameter does not result in an outage and the change is asynchronously applied as soon as possible"
  type        = bool
  default     = false
}

variable "auto_minor_version_upgrade" {
  description = "Indicates that minor engine upgrades will be applied automatically to the DB instance during the maintenance window"
  type        = bool
  default     = true
}

variable "apply_immediately" {
  description = "Specifies whether any database modifications are applied immediately, or during the next maintenance window"
  type        = bool
  default     = false
}

variable "maintenance_window" {
  description = "The window to perform maintenance in. Syntax: 'ddd:hh24:mi-ddd:hh24:mi'. Eg: 'Mon:00:00-Mon:03:00'"
  type        = string
  default = "Mon:00:00-Mon:03:00"
}

variable "skip_final_snapshot" {
  description = "Determines whether a final DB snapshot is created before the DB instance is deleted. If true is specified, no DBSnapshot is created. If false is specified, a DB snapshot is created before the DB instance is deleted, using the value from final_snapshot_identifier"
  type        = bool
  default     = true
}

variable "copy_tags_to_snapshot" {
  description = "On delete, copy all Instance tags to the final snapshot (if final_snapshot_identifier is specified)"
  type        = bool
  default     = false
}

variable "backup_retention_period" {
  description = "The days to retain backups for"
  type        = number
  default     = 1
}

variable "backup_window" {
  description = "The daily time range (in UTC) during which automated backups are created if they are enabled. Example: '09:46-10:16'. Must not overlap with maintenance_window"
  type        = string
  default   = "03:00-06:00"
}

variable "tags" {
  description = "A mapping of tags to assign to all resources"
  type        = map(string)
  default     = {}
}



# DB subnet group
variable "subnet_ids" {
  description = "A list of VPC subnet IDs"
  type        = list(string)
  default     = []
}

# DB parameter group
variable "family" {
  description = "The family of the DB parameter group"
  type        = string
  default     = ""
}

variable "parameters" {
  description = "A list of DB parameters (map) to apply"
  type        = list(map(string))
  default     = []
}

# DB option group
variable "option_group_description" {
  description = "The description of the option group"
  type        = string
  default     = ""
}

variable "major_engine_version" {
  description = "Specifies the major version of the engine that this option group should be associated with"
  type        = string
  default     = "5.7"
}

variable "options" {
  description = "A list of Options to apply."
  type        = any
  default     = []
}

variable "create_db_subnet_group" {
  description = "Whether to create a database subnet group"
  type        = bool
  default     = true
}

variable "create_db_parameter_group" {
  description = "Whether to create a database parameter group"
  type        = bool
  default     = true
}

variable "create_db_option_group" {
  description = "(Optional) Create a database option group"
  type        = bool
  default     = true
}

variable "create_db_instance" {
  description = "Whether to create a database instance"
  type        = bool
  default     = true
}

variable "timezone" {
  description = "(Optional) Time zone of the DB instance. timezone is currently only supported by Microsoft SQL Server. The timezone can only be set on creation. See MSSQL User Guide for more information."
  type        = string
  default     = ""
}

variable "character_set_name" {
  description = "(Optional) The character set name to use for DB encoding in Oracle instances. This can't be changed. See Oracle Character Sets Supported in Amazon RDS for more information"
  type        = string
  default     = ""
}

variable "enabled_cloudwatch_logs_exports" {
  description = "List of log types to enable for exporting to CloudWatch logs. If omitted, no logs will be exported. Valid values (depending on engine): alert, audit, error, general, listener, slowquery, trace, postgresql (PostgreSQL), upgrade (PostgreSQL)."
  type        = list(string)
  default     = []
}

variable "timeouts" {
  description = "(Optional) Updated Terraform resource management timeouts. Applies to `aws_db_instance` in particular to permit resource management times"
  type        = map(string)
  default = {
    create = "40m"
    update = "80m"
    delete = "40m"
  }
}

variable "option_group_timeouts" {
  description = "Define maximum timeout for deletion of `aws_db_option_group` resource"
  type        = map(string)
  default = {
    delete = "15m"
  }
}

variable "internal" {
  description = "If true, ELB will be an internal ELB"
  type        = bool
  default    =  "false"
}


variable "deletion_protection" {
  description = "The database can't be deleted when this value is set to true."
  type        = bool
  default     = false
}

variable "use_parameter_group_name_prefix" {
  description = "Whether to use the parameter group name prefix or not"
  type        = bool
  default     = true
}

variable "performance_insights_enabled" {
  description = "Specifies whether Performance Insights are enabled"
  type        = bool
  default     = false
}

variable "performance_insights_retention_period" {
  description = "The amount of time in days to retain Performance Insights data. Either 7 (7 days) or 731 (2 years)."
  type        = number
  default     = 7
}

variable "max_allocated_storage" {
  description = "Specifies the value for Storage Autoscaling"
  type        = number
  default     = 0
}

variable "ca_cert_identifier" {
  description = "Specifies the identifier of the CA certificate for the DB instance"
  type        = string
  default     = "rds-ca-2019"
}

variable "delete_automated_backups" {
  description = "Specifies whether to remove automated backups immediately after the DB instance is deleted"
  type        = bool
  default     = true
}

variable "db_parameter_group" {
  description = "Specifies the db_parameter_group for the DB instance"
  type        = string
  default     = "mysql5.7"
}