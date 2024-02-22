module "vpc" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-vpc.git"


  for_each   = var.vpc
  cidr_block = each.value["cidr_block"]
  subnets    = each.value["subnets"]

  env = var.env
  tags = var.tags

  default_vpc_id = var.default_vpc_id
  default_vpc_rt = var.default_vpc_rt

}


module "rabbitmq" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-rabbitmq.git"

  for_each        = var.rabbitmq
  component       = each.value["component"]
  instance_type   = each.value["instance_type"]

  sg_subnets_cidr = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)
  vpc_id          = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  subnet_id       = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)[0]

  allow_ssh_cidr  =var.allow_ssh_cidr
  zone_id         = var.zone_id
  kms_key_arn      = var.kms_key_arn

  env  = var.env
  tags = var.tags
}


module "rds" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-rds.git"


  for_each        = var.rds
  component       = each.value["component"]
  engine          = each.value["engine"]
  engine_version  = each.value["engine_version"]
  database_name   = each.value["database_name"]
  subnet_ids      = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)
  instance_count  = each.value["instance_count"]
  instance_class  = each.value["instance_class"]
  vpc_id          = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_subnets_cidr = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)


  tags = var.tags
  env  = var.env

  kms_key_arn = var.kms_key_arn
}


module "documentdb" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-documentdb.git"


  for_each        = var.documentdb
  component       = each.value["component"]
  subnet_ids      = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)
  vpc_id          = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_subnets_cidr = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)
  engine            = each.value["engine"]
  engine_version    = each.value["engine_version"]
  db_instance_count = each.value["db_instance_count"]
  instance_class    = each.value["instance_class"]


  tags = var.tags
  env  = var.env

  kms_key_arn = var.kms_key_arn
}


module "elasticache" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-elasticache.git"


  for_each                = var.elasticache
  component               = each.value["component"]
  subnet_ids              = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), "db", null), "subnet_ids", null)
  vpc_id                  = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  engine                  = each.value["engine"]
  engine_version          = each.value["engine_version"]
  replicas_per_node_group = each.value["replicas_per_node_group"]
  num_node_groups         = each.value["num_node_groups"]
  sg_subnets_cidr         = lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)
  node_type               = each.value["node_type"]
  parameter_group_name    = each.value["parameter_group_name"]

  tags = var.tags
  env  = var.env

  kms_key_arn = var.kms_key_arn
}

module "alb" {
  source = "git::https://github.com/paulpremkumar241122/terraform-module-alb.git"

  for_each           = var.alb
  name               = each.value["name"]
  internal           = each.value["internal"]
  load_balancer_type = each.value["load_balancer_type"]
  vpc_id             = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  sg_subnets_cidr    = each.value["name"] =="public" ? [ "0.0.0.0/0" ] : local.app_web_subnet_cidr
  subnets            = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), each.value["subnets_ref"], null), "subnet_ids", null)


  tags = var.tags
  env  = var.env
}

module "apps" {

  depends_on = [module.vpc, module.alb, module.rds, module.documentdb, module.elasticache, module.rabbitmq]

  source = "git::https://github.com/paulpremkumar241122/terraform-module-app.git"

  for_each         = var.apps
  app_port         = each.value["app_port"]
  instance_type    = each.value["instance_type"]
  desired_capacity = each.value["desired_capacity"]
  max_size         = each.value["max_size"]
  min_size         = each.value["min_size"]
  component        = each.value["component"]
  sg_subnets_cidr  = each.value["component"] == "frontend" ? local.public_web_subnet_cidr : lookup(lookup(lookup(lookup(var.vpc, "main", null), "subnets", null), "app", null), "cidr_block", null)
  subnets          = lookup(lookup(lookup(lookup(module.vpc, "main", null), "subnet_ids", null), each.value["subnets_ref"], null), "subnet_ids", null)
  vpc_id           = lookup(lookup(module.vpc, "main", null), "vpc_id", null)
  allow_ssh_cidr   = var.allow_ssh_cidr
  allow_prometheus_cidr = var.allow_prometheus_cidr
  lb_dns_name      = lookup(lookup(module.alb, each.value["lb_ref"], null), "dns_name", null)
  listener_arn     = lookup(lookup(module.alb, each.value["lb_ref"], null), "listener_arn", null)
  lb_rule_priority = each.value["lb_rule_priority"]
  database_iam_permission = try(each.value [ "database_iam_permission" ], [])

  env  = var.env
  tags = var.tags
  kms_arn      = var.kms_key_arn
  kms_key_id   = var.kms_key_arn
}
