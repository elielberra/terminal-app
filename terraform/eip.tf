# The allocation itself is deliberately NOT managed here — it is only looked up.
# That way no apply or destroy can ever release the address and lose the DNS
# record / cert validation path.
data "aws_eip" "app" {
  id = var.eip_allocation_id
}

resource "aws_eip_association" "app" {
  instance_id   = aws_instance.app.id
  allocation_id = data.aws_eip.app.id
}
