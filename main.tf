module "vpc" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-vpc.git"


  for_each = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets = each.value["subnets"]

  env = var.env
  tags = var.tags
  default_vpc_id = var.default_vpc_id

}

#module "app_server" {
#  source = "git::https://github.com/paulpremkumar241122/terraform-module-app.git"
#  env = var.env
#  tags = var.tags
#  component = "test"
#  subnet_id =
#}

output "subnet_ids" {
  value = module.vpc
}