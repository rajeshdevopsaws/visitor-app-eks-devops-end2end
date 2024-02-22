resource "aws_vpc" "visitor-eks-vpc" {
  cidr_block           = var.vpc_cidr
  enable_dns_support   = true
  enable_dns_hostnames = true

  tags = {
    Name = "visitor-eks-${random_string.suffix.result}"
  }
}
