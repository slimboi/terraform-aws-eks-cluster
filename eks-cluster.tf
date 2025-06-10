module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name                   = "myapp-eks-cluster"
  cluster_version                = "1.32"
  cluster_endpoint_public_access = true

  subnet_ids = module.myapp_vpc.private_subnets
  vpc_id     = module.myapp_vpc.vpc_id

  tags = {
    environment = "dev"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {

      instance_types = ["t2.small"]

      min_size     = 1
      max_size     = 3
      desired_size = 3
    }
  }
}