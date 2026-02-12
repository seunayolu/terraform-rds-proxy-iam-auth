resource "aws_instance" "node_app_instance" {
  ami                         = data.aws_ami.ubuntu.id
  instance_type               = var.instance_type
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = var.security_group_ids
  iam_instance_profile        = var.iam_instance_profile
  associate_public_ip_address = true

  user_data = file("${path.module}/script/userdata.sh")

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = var.volume_type
    delete_on_termination = true
  }

  tags = {
    Name        = "${var.project_name}-node-app"
    Environment = var.environment
  }
}