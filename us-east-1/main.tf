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

module "elb_security_group" {
  source  = "git@github.com:iestarks/terraform-aws-security-group.git"
  vpc_id = data.aws_vpc.this.id
  name = var.name
#   tags = merge(
#     {
#       "Name" = format("%s", var.name)
#     },
#     var.elb-sg-tag,
#   )
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

#########Subnet data from VPC

data "aws_subnet_ids" "all" {
  vpc_id = data.aws_vpc.this.id
}

######Security Group
data "aws_security_group" "this" {
  vpc_id = data.aws_vpc.this.id
  name   = "usbank-app-sg"
}

data "aws_instances" "get_instances" {
    filter {
        name = "instance-type"
        values = ["t2.micro"]
    }

filter {
    name = "availability-zone"
    #values = [data.aws_availability_zones.available.values]
    values = var.azs
}

instance_state_names = ["running", "stopped"]
}


data "aws_ami" "ubuntu" {
  most_recent = true

  filter {
    name   = "name"
    values = ["ubuntu/images/hvm-ssd/ubuntu-focal-20.04-amd64-server-*"]
  }

  filter {
    name   = "virtualization-type"
    values = ["hvm"]
  }

  owners = ["099720109477"] # Canonical

 tags = {
    owners = var.owner
    Environment = var.env
    }
  }

#######Load Balancer Instances

resource "aws_instance" "web" {
  ami           = data.aws_ami.ubuntu.id
  instance_type = "t3.micro"

  tags = {
    Name = "loadbalancer_instance"
  }
}




module "elb_http" {
  source = "./modules/terraform-aws-elb/modules/elb/"
   #security_groups = data.aws_security_group.this.id
   subnets  = ["subnet-0e20da1368e759895","subnet-0362a51a955d46f09"]
   internal   = var.listener
   vpc_id = data.aws_vpc.this.id

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
    target              = var.target
    interval            = var.interval
    healthy_threshold   = var.healthy_threshold
    unhealthy_threshold = var.unhealthy_threshold
    timeout             = var.timeout
  }

  access_logs = {
    bucket = "usbank-bucket"
  }
}


module "usbank-autoscaling"{
  source = "git@github.com:iestarks/terraform-aws-autoscaling.git"
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








# # Create a new load balancer attachment
# resource "aws_elb_attachment" "usbank_elb_attachment" {
#   elb      = module.elb_http.id
#   instance = aws_instance.web.id
# }
