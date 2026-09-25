# Replaces the console-created "launch-wizard-2" group. Web traffic no longer
# reaches the instance directly (cloudflared makes an outbound-only tunnel to
# Cloudflare's edge), so only SSH stays open.
resource "aws_security_group" "app" {
  name        = "terminal-app-sg"
  description = "terminal-app: SSH only (web traffic arrives via Cloudflare Tunnel)"
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

resource "aws_vpc_security_group_egress_rule" "all" {
  security_group_id = aws_security_group.app.id
  description       = "All outbound"
  ip_protocol       = "-1"
  cidr_ipv4         = "0.0.0.0/0"
}
