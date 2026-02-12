resource "aws_subnet" "public" {
  for_each = toset(local.azs)

  vpc_id                  = aws_vpc.main.id
  cidr_block              = cidrsubnet(var.vpc_cidr, 4, index(local.azs, each.value))
  availability_zone       = each.value
  map_public_ip_on_launch = true

  tags = {
    Name        = "${var.project_name}-${var.environment}-public-${each.value}"
    Environment = var.environment
  }
}

resource "aws_subnet" "private" {
  for_each = toset(local.azs)

  vpc_id            = aws_vpc.main.id
  cidr_block        = cidrsubnet(var.vpc_cidr, 4, index(local.azs, each.value) + length(local.azs))
  availability_zone = each.value

  tags = {
    Name        = "${var.project_name}-${var.environment}-private-${each.value}"
    Environment = var.environment
  }
}