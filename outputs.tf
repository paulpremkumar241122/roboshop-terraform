#output "subnet_ids" {
#  value = module.vpc
#}


output "subnet_ids" {
  value = module.vpc["subnet"]["subnet_ids"][0]
}