# Replaces the console-created "launch-wizard-2" group. Same rules: 22/80/443
# open to the world (22 stays open because GitHub Actions runners have
# unpredictable source IPs and need to reach it for deploys), all outbound.
resource "aws_security_group" "app" {
  name        = "terminal-app-sg"
  description = "terminal-app: SSH, HTTP (certbot challenge + onion), HTTPS"
  vpc_id      = data.aws_vpc.default.id

  tags = {
    Name = "terminal-app-sg"
  }
}

resource "aws_vpc_security_group_ingress_rule" "ssh" {
  security_group_id = aws_security_group.app.id
  description       = "SSH (admin access, CI/CD deploys)"
  from_port         = 22
  to_port           = 22
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "http" {
  security_group_id = aws_security_group.app.id
  description       = "HTTP (certbot ACME challenge, onion service)"
  from_port         = 80
  to_port           = 80
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_ingress_rule" "https" {
  security_group_id = aws_security_group.app.id
  description       = "HTTPS (the app)"
  from_port         = 443
  to_port           = 443
  ip_protocol       = "tcp"
  cidr_ipv4         = "0.0.0.0/0"
}

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.app.id
  description       = "All outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
