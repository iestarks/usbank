resource "aws_instance" "unbuntu" {
   ami             = var.aws_ami
   instance_type   = var.instance_type
  
   tags = {
        name   = var.instance_name
   }
}