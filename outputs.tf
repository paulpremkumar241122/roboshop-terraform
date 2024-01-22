#output "subnet_ids" {
#  value = module.vpc
#}


output "subnet_ids" {
  value = module.vpc["subnet"]["app"]["subnet_ids"][0]
}