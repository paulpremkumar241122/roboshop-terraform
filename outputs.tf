#output "subnet_ids" {
#  value = module.vpc
#}


output "subnet_ids" {
  value = module.vpc["main"]["subnets"]["app"].aws_subnet.main[0]
}