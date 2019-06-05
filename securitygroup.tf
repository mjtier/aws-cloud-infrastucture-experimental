resource "aws_security_group" "CacheSecurityGroup" {
  name        = "CacheSecurityGroup"
  vpc_id      = aws_vpc.main.id
  description = "Security Group for SQLite Cache instances"

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

