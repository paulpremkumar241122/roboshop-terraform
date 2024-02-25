env = "prod"


tags = {
  company_name  = "Vagdevi Tech"
  business      = "Ecommerce"
  business_unit = "retail"
  cost_center   = "2411"
  project_name  = "Roboshop"
}

vpc = {
  main = {
    cidr_block = "10.10.0.0/16"
    subnets    = {
      public   = { cidr_block = [ "10.10.0.0/24", "10.10.1.0/24" ] }
      web      = { cidr_block = [ "10.10.2.0/24", "10.10.3.0/24" ] }
      app      = { cidr_block = [ "10.10.4.0/24", "10.10.5.0/24" ] }
      db       = { cidr_block = [ "10.10.6.0/24", "10.10.7.0/24" ] }
    }
  }
}

default_vpc_id = "vpc-03467d07ad2f770e5"
default_vpc_rt = "rtb-0caa71941830cf02e"

### allowing workstaion to access rabbitmq instance  - allow_ssh_cidr = workstaion - ip/32
### so why we are giving /32 is bacause it is only 1 instance .
allow_ssh_cidr        = [ "172.31.39.155/32" ]
allow_prometheus_cidr = [ "172.31.41.212/32", "172.31.37.48/32" ]
#added grafana ip also in prometheus.
zone_id               = "Z0866621F4YFMPDO5E0L"
kms_key_id            = "5ccefc9a-0cc1-49a5-a6b0-4ed8e995551c"
kms_key_arn           = "arn:aws:kms:us-east-1:461355683695:key/5ccefc9a-0cc1-49a5-a6b0-4ed8e995551c"


rabbitmq = {
  main = {
    instance_type = "t3.medium"
    component     = "rabbitmq"
  }
}

rds = {
  main = {
    component        = "rds"
    engine           = "aurora-mysql"
    engine_version   = "5.7.mysql_aurora.2.11.3"
    database_name    = "Vagdevi"
    instance_count   = 1
    instance_class   = "db.t3.medium"
  }
}

documentdb = {
  main = {
    component         = "docdb"
    engine            = "docdb"
    engine_version    = "4.0.0"
    db_instance_count = 1
    instance_class    = "db.t3.medium"

  }
}

elasticache = {
  main = {
    component               = "elasticache"
    engine                  = "redis"
    engine_version          = "6.x"
    replicas_per_node_group = 1
    num_node_groups         = 1
    node_type               = "cache.t3.medium"
    parameter_group_name    = "default.redis6.x.cluster.on"
  }
}

alb = {
  public = {
    name               = "public"
    internal           = false
    load_balancer_type = "application"
    subnets_ref        = "public"

  }
  private = {
    name               = "private"
    internal           = true
    load_balancer_type = "application"
    subnets_ref        = "app"

  }
}

apps = {
  frontend = {
    component        = "frontend"
    app_port         = 80
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnets_ref      = "web"
    lb_ref           = "public"
    lb_rule_priority = 100
  }
  catalogue = {
    component        = "catalogue"
    app_port         = 8080
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnets_ref      = "app"
    lb_ref           = "private"
    lb_rule_priority = 102
    database_iam_permission = [ "arn:aws:ssm:us-east-1:461355683695:parameter/roboshop.prod.docdb.*" ]
  }
  cart = {
    component        = "cart"
    app_port         = 8080
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnets_ref      = "app"
    lb_ref           = "private"
    lb_rule_priority = 103
  }
  user = {
    component        = "user"
    app_port         = 8080
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnets_ref      = "app"
    lb_ref           = "private"
    lb_rule_priority = 100
    database_iam_permission = [ "arn:aws:ssm:us-east-1:461355683695:parameter/roboshop.prod.docdb.*" ]
  }
  shipping = {
    component        = "shipping"
    app_port         = 8080
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnets_ref      = "app"
    lb_ref           = "private"
    lb_rule_priority = 104
    database_iam_permission = [ "arn:aws:ssm:us-east-1:461355683695:parameter/roboshop.prod.mysql.*" ]
  }
  payment = {
    component        = "payment"
    app_port         = 8080
    instance_type    = "t3.small"
    desired_capacity = 2
    max_size         = 5
    min_size         = 2
    subnets_ref      = "app"
    lb_ref           = "private"
    lb_rule_priority = 105
  }
}