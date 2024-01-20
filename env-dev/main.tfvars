env = "dev"

components = {

  frontend = {
    tags = { Monitor = "true", env = "dev"}
  }
  mongodb = {
    tags = { env = "dev"}
  }
  catalogue = {
    tags = { Monitor = "true", env = "dev"}
  }
  redis = {
    tags = { env = "dev"}
  }
  user = {
    tags = { Monitor = "true", env = "dev"}
  }
  cart = {
    tags = { Monitor = "true", env = "dev"}
  }
  mysql = {
    tags = { env = "dev"}
  }
  shipping = {
    tags = { Monitor = "true", env = "dev"}
  }
  rabbitmq = {
    tags = { env = "dev"}
  }
  payment = {
    tags = { Monitor = "true", env = "dev"}
  }
  dispatch = {
    tags = { Monitor = "true", env = "dev"}
  }
}

tags = {
  company_name = "Vagdevi Tech"
  business = "Ecommerce"
  business_unit = "retail"
  cost_center = "2411"
  project_name = "Roboshop"
}

vpc = {
  main = {
    cidr_block = "10.0.0.0/16"
    web_subnet_cidr_block = ["10.0.0.0/24"]
  }
}