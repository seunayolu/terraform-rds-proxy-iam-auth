resource "aws_ec2_managed_prefix_list" "main" {
  name           = "Public IPs"
  address_family = "IPv4"
  max_entries    = 5

  entry {
    cidr        = var.publicip-01
    description = "Public IP from STRLNK"
  }

  entry {
    cidr        = var.publicip-02
    description = "Public IP from ARTL"
  }

  tags = { Name = "${var.project_name}-my_ips" }
}