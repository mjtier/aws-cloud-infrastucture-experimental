# SECURITY GROUP FOR backend servers exposing ssh port 22
# TODO link this to default VPC
resource "aws_security_group" "cache-securitygroup" {
  name = "cache-securitygroup"
  description = "Security Group for Cache instances"

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }


  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}