locals {
  route_table_ids = concat(module.vpc.private_route_table_ids, module.vpc.public_route_table_ids)
}

module "hcp" {
  source                    = "joatmon08/hcp/aws"
  version                   = "0.3.0"
  hvn_cidr_block            = var.hcp_consul_cidr_block
  hvn_name                  = var.name
  hvn_region                = var.region
  number_of_route_table_ids = length(local.route_table_ids)
  route_table_ids           = local.route_table_ids
  vpc_cidr_block            = module.vpc.vpc_cidr_block
  vpc_id                    = module.vpc.vpc_id
  vpc_owner_id              = module.vpc.vpc_owner_id
}