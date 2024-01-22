#output "subnet_ids" {
#  value = module.vpc
#}


output "subnet_ids" {
  value = module.vpc["subnet_ids"]["subnet_id"]["app"]["subnet_ids"][0]
}