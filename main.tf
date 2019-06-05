data "aws_availability_zones" "available" {}

resource "aws_key_pair" "mykey" {
  key_name = "${var.key_name}"
  public_key = "${file("${var.public_key}")}"
}


/* INSTANCE TO BE USED IN THE AUTOSCALE */
resource "aws_instance" "sqlite-cache" {
  ami                         = "${var.ami_id}"
  instance_type               = "t2.micro"
  key_name                    = "${aws_key_pair.mykey.key_name}"
  associate_public_ip_address = true

  tags = {
    Name      = "sqlite-cache"
    Terraform = "true"
  }

  connection {
    host        = "${self.public_ip}"
    type        = "ssh"
    user        = "ec2-user"
    private_key = "${file("${var.private_key}")}"
  }

  vpc_security_group_ids = ["${aws_security_group.cache-securitygroup.id}"]

  
  provisioner "file" {
    source      = "exportdb.sh"
    destination = "/tmp/exportdb.sh"
  }
  
  provisioner "file" {
    source      = "exportdb.sh"
    destination = "/tmp/exportdb.sh"
  }
  
  provisioner "file" {
    source      = "importdb.sh"
    destination = "/tmp/exportdb.sh"
  }
  
  provisioner "remote-exec" {
    inline = [
      "sudo pip3 install --upgrade awscli",
      "chmod a+x /tmp/export.db",
      "chmod a+x /tmp/import.db",
      "crontab -e */5 * * * *  /tmp/exportdb.sh"
    ]
  }

}

# CREATE CUSTOM AMI
resource "aws_ami_from_instance" "cache-ami" {
  name               = "cache-ami"
  source_instance_id = "${aws_instance.sqlite-cache.id}"
}


# Launch CONFIGURATION FOR AUTOSCALING 
/*
resource "aws_launch_configuration" "db_server" {
  name = "db"

  image_id        = "${aws_ami_from_instance.cache-ami.id}"
  instance_type   = "t2.micro"
  security_groups = ["${aws_security_group.backend.id}"]
  key_name        = "${var.key_name}"

  lifecycle {
    create_before_destroy = true
  }
}

# AUTOSCALING 
resource "aws_autoscaling_group" "backend_autoscaling" {
  name = "backend_group"

  launch_configuration = "${aws_launch_configuration.backend_server.id}"
  availability_zones   = ["${data.aws_availability_zones.available.names}"]
  min_size             = 1
  max_size             = 1
  health_check_type    = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}
*/
