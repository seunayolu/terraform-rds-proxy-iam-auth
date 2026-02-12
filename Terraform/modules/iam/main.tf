resource "aws_iam_role" "ec2_instance_role" {
  name               = "${var.project_name}-ec2-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = {
    Name        = "${var.project_name}-ec2-instance-role"
    Environment = var.environment
  }
}

# Policy
resource "aws_iam_policy" "ssm_parameter_rds_proxy" {
  name   = "${var.project_name}-ec2-instance-policy"
  policy = data.aws_iam_policy_document.ec2_instance_iam_policy.json
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "attach_ssm_rds_proxy" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = aws_iam_policy.ssm_parameter_rds_proxy.arn
}

# Attach the Managed Policy for Session Manager (SSM)
resource "aws_iam_role_policy_attachment" "ec2_ssm_managed" {
  role       = aws_iam_role.ec2_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}

# Instance Profile
resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "${var.project_name}-instance-profile"
  role = aws_iam_role.ec2_instance_role.name
}

resource "aws_iam_role" "rds_proxy_role" {
  name               = "${var.project_name}-rds_proxy-role"
  assume_role_policy = data.aws_iam_policy_document.rds_proxy_assume_role_policy.json

  tags = {
    Name        = "${var.project_name}-rds-proxy-role"
    Environment = var.environment
  }
}

# Policy
resource "aws_iam_policy" "rds_proxy_policy" {
  name   = "${var.project_name}-rds-proxy-policy"
  policy = data.aws_iam_policy_document.rds_proxy_iam_policy.json
}

# Policy Attachment
resource "aws_iam_role_policy_attachment" "rds_proxy_policy_attachment" {
  role       = aws_iam_role.rds_proxy_role.name
  policy_arn = aws_iam_policy.rds_proxy_policy.arn
}