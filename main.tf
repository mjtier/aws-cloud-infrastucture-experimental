/*
resource "aws_instance" "sqlite-cache-instance" {
  ami                    = "ami-04a3d424ed14a1996"
  instance_type          = "t2.micro"
  key_name               = aws_key_pair.keypair.key_name
  vpc_security_group_ids = [aws_security_group.CacheSecurityGroup.id]
  subnet_id              = aws_subnet.default.id

  #The file provisioner is used to copy files or directories from the machine executing Terraform to the newly created resource.
  iam_instance_profile = aws_iam_instance_profile.web_instance_profile.id
}
*/

# Launch CONFIGURATION FOR AUTOSCALING 

resource "aws_launch_configuration" "db_server" {
  image_id        = "ami-04a3d424ed14a1996"
  instance_type   = "t2.micro"
  security_groups = [aws_security_group.CacheSecurityGroup.id]
  key_name        = aws_key_pair.keypair.key_name

  lifecycle {
    create_before_destroy = true
  }
  user_data = "${file("setup.sh")}"
  iam_instance_profile = aws_iam_instance_profile.web_instance_profile.id
  
}

# AUTOSCALING 
resource "aws_autoscaling_group" "backend_autoscaling" {
  launch_configuration =  aws_launch_configuration.db_server.id
  #availability_zones   = [ "us-east-1a" ]
  vpc_zone_identifier = ["${aws_subnet.default.id}"]
  min_size             = 1
  max_size             = 1
  health_check_type    = "EC2"

  lifecycle {
    create_before_destroy = true
  }

}

