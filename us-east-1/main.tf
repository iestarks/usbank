##############################################################
# Data sources to get security group details
##############################################################


###########################
# Security groups for MySQL
###########################
module "mysql_security_group" {
  #source  = "terraform-aws-modules/security-group/aws//modules/mysql"
  source  = "git@github.com:iestarks/terraform-aws-security-group.git"
  name = var.name
  vpc_id = var.vpc_id
  ingress_cidr_blocks = var.ingress_cidr_blocks
}


##############################################################
# Data sources to get VPC, subnets and security group details
##############################################################
data "aws_vpc" "this" {
  filter {
    name = "tag:Name"
    values = ["bankus_east-2-vpc"]
  }
}


data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.this.id
}

data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id
  name   = "usbank-app-sg"
}


module "usbank-main-autoscaling"{
  # source = "git@github.com:iestarks/terraform-aws-autoscaling.git"
  source  = "../../"
  #name = var.asgname
  # vpc_zone_identifier = data.aws_subnet_ids.all.ids
  # health_check_type         = var.health_check_type
  # min_size                  = var.min_size
  # max_size                  = var.max_size
  # desired_capacity          = var.desired_capacity
  # wait_for_capacity_timeout = var.wait_for_capacity_timeout
  # image_id = var.image_id
  # create_lc = var.create_lc
  # instance_type = var.instance_type
  # security_groups = [data.aws_security_group.this.id]
}

###############################################
##Give Bucket Permission and allow access for the ELB
#########################################################

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


#data "aws_instance" "this" {}



module "elb_http" {
  source  = "git@github.com:iestarks/terraform-aws-elb.git"

  name = "elb-usbank"

  #subnets         = data.aws_subnet_ids.all.ids
  
  //Improve by automatically selecting the subnets per az

  subnets  = ["subnet-0e20da1368e759895","subnet-0362a51a955d46f09"]
  security_groups = [data.aws_security_group.this.id]

  internal        = false

  listener = [
    {
      instance_port     = var.lb_port
      instance_protocol = "HTTP"
      lb_port           = var.lb_port
      lb_protocol       = "HTTP"
    },
    {
     instance_port     = var.instance_port
      instance_protocol = "http"
      lb_port           = var.lb_port
      lb_protocol       = "http"
      
      //Improvement run the modules for SSL cert generation and insert output here
      #ssl_certificate_id = "arn:aws:acm:eu-west-1:235367859451:certificate/6c270328-2cd5-4b2d-8dfd-ae8d0004ad31"
    },
  ]

  health_check = {
    target              = var.target
    interval            = var.interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
  }

  access_logs = {
    bucket = "usbank-bucket"
  }

  // ELB attachments
  #number_of_instances = module.usbank-main-autoscaling.this_autoscaling_group_desired_capacity
  number_of_instances = var.number_of_instances
  
  instances           = [module.usbank_asg.instance_ids]
  #instances   = data.aws_instance.this.*.id


  tags = {
    Owner = var.owner
    Environment = var.env
  }
}



#####Predictive Scaling Plan

#############################################################################

data "aws_launch_configuration" "this"{
  #name = module.usbank-main-autoscaling.this_launch_configuration_id
  name = ""
}

data "aws_availability_zones" "available" {}

resource "aws_autoscaling_group" "bankus_asg" {
  name_prefix = "usbank_asg"

  launch_configuration = data.aws_launch_configuration.this.name
  availability_zones   = [data.aws_availability_zones.available.names[0]]

  min_size = var.min_size
  max_size = var.max_size

  tags = [
    {
      key                 = "application"
      value               = "example"
      propagate_at_launch = true
    },
  ]
}

resource "aws_autoscalingplans_scaling_plan" "example" {
  name = "example-predictive-cost-optimization"

  application_source {
    tag_filter {
      key    = "application"
      values = ["example"]
    }
  }

  scaling_instruction {
    disable_dynamic_scaling = true

    max_capacity       = var.max_size
    min_capacity       = var.min_size
    resource_id        = format("autoScalingGroup/%s", aws_autoscaling_group.bankus_asg.name)
    scalable_dimension = "autoscaling:autoScalingGroup:DesiredCapacity"
    service_namespace  = "autoscaling"

    target_tracking_configuration {
      predefined_scaling_metric_specification {
        predefined_scaling_metric_type = "ASGAverageCPUUtilization"
      }

      target_value = 70
    }

    predictive_scaling_max_capacity_behavior = "SetForecastCapacityToMaxCapacity"
    predictive_scaling_mode                  = "ForecastAndScale"

    predefined_load_metric_specification {
      predefined_load_metric_type = "ASGTotalCPUUtilization"
    }
  }
}
