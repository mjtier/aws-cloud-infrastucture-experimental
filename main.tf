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
resource "aws_iam_role" "test" {
  name               = "test-role"
  assume_role_policy = "${file("assume-role-policy.json")}"
}

resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = "${file("policy-s3-bucket.json")}"
}

resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  roles      = ["${aws_iam_role.test.name}"]
  policy_arn = "${aws_iam_policy.policy.arn}"
}

resource "aws_iam_instance_profile" "test_profile" {
  name  = "test_profile"
  role = aws_iam_role.test.name
}

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
  iam_instance_profile   = "${aws_iam_instance_profile.test_profile.name}"
  
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

