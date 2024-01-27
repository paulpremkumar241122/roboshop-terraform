env = "dev"

tags = {
  company_name  = "XYZ Tech"
  business      = "ecommerce"
  business_unit = "retail"
  cost_center   = "322"
  project_name  = "roboshop"
}

default_vpc_id = "vpc-03467d07ad2f770e5"
default_vpc_rt = "rtb-0caa71941830cf02e"

### allowing workstaion to access rabbitmq instance  - allow_ssh_cidr = workstaion - ip/32
### so why we are giving /32 is bacause it is only 1 instance .
allow_ssh_cidr = ["172.31.39.155/32"]
zone_id        = "Z0866621F4YFMPDO5E0L"
kms_key_id     = "5ccefc9a-0cc1-49a5-a6b0-4ed8e995551c"
kms_key_arn    = "arn:aws:kms:us-east-1:461355683695:key/5ccefc9a-0cc1-49a5-a6b0-4ed8e995551c"


rabbitmq = {
  main = {
    instance_type = "t3.small"
    component     = "rabbitmq"
  }
}

rds ={
  main = {
    component               = "mysql"
    engine                  = "aurora-mysql"
    engine_version          = "5.7.mysql_aurora.2.11.3"
    database_name           = "Vagdevi"
  }
}
