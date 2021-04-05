resource "aws_security_group_rule" "ingress_hcp" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  cidr_blocks       = [var.hcp_consul_cidr_block]
  security_group_id = module.eks.cluster_primary_security_group_id
  description       = "Allow all TCP traffic between HCP and EKS"
}

module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  version         = "14.0.0"
  cluster_name    = var.name
  cluster_version = "1.18"
  subnets         = module.vpc.private_subnets

  tags = var.tags

  vpc_id           = module.vpc.vpc_id
  write_kubeconfig = false

  node_groups_defaults = {
    ami_type  = "AL2_x86_64"
    disk_size = 50
  }

  node_groups = {
    hcp = {
      desired_capacity = 3
      max_capacity     = 3
      min_capacity     = 3

      instance_type   = "t2.small"
      k8s_labels      = var.tags
      additional_tags = var.additional_tags
    }
  }
}

data "aws_eks_cluster" "cluster" {
  name = module.eks.cluster_id
}

data "aws_eks_cluster_auth" "cluster" {
  name = module.eks.cluster_id
}

provider "kubernetes" {
  host                   = data.aws_eks_cluster.cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.cluster.token
}