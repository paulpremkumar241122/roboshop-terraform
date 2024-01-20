module "vpc" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-vpc.git"
  for_each = var.vpc

  cidr_block = each.value[ "cidr_block" ]
  web_subnet_cidr_block = each.value["web_subnet_cidr_block"]

  env = var.env
  tags = var.tags
}