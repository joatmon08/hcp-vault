resource "aws_security_group" "rds" {
  name        = "${var.environment_name}-rds-sg"
  description = "Postgres traffic"

  tags = {
    Name = var.environment_name
  }

  # Postgres traffic
  ingress {
    from_port   = 5432
    to_port     = 5432
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

