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
  // associate_public_ip_address = true

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

  /* SQLite DB Export Executable */
  provisioner "file" {
    source      = "${path.module}/config/nginx-default.conf"
    destination = "/tmp/nginx-default.conf"
  }
  
  /* SQLite DB Importt Executable */
  provisioner "file" {
    source      = "${path.module}/config/nginx.gzip.conf"
    destination = "/tmp/nginx.gzip.conf"
  }


  /* NGINX install and setup */
  provisioner "remote-exec" {
    inline = [
      "sudo apt-get update",
      "sudo apt-get install nginx nginx-extras -y",
      "sudo mv /tmp/nginx-default.conf /etc/nginx/sites-available/default",
      "sudo mv /tmp/nginx.gzip.conf /etc/nginx/conf.d/gzip.conf",
      "sudo systemctl enable nginx",
      "sudo systemctl start nginx",
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
resource "aws_launch_configuration" "backend_server" {
  name = "backend"

  image_id        = "${aws_ami_from_instance.backend-ami.id}"
  instance_type   = "${var.ec2type}"
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
  min_size             = 2
  max_size             = 2
  health_check_type    = "EC2"

  lifecycle {
    create_before_destroy = true
  }
}
*/
