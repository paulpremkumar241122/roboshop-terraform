module "instances" {
  for_each = var.components
  source = "git::https://github.com/paulpremkumar241122/terraform-module-app.git"
  component = each.key
  env = var.env
  tags = merge(each.value["tags"], var.tags)
}
