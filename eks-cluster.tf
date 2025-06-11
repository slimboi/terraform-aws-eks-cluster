module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.36.0"

  cluster_name                    = "myapp-eks-cluster"
  cluster_version                 = "1.32"
  cluster_endpoint_public_access  = true
  cluster_endpoint_private_access = true

  subnet_ids = module.myapp_vpc.private_subnets
  vpc_id     = module.myapp_vpc.vpc_id

  # Enable cluster logging
  cluster_enabled_log_types = ["api", "audit", "authenticator", "controllerManager", "scheduler"]

  # Cluster access entry
  enable_cluster_creator_admin_permissions = true

  tags = {
    environment = "dev"
    application = "myapp"
  }

  eks_managed_node_groups = {
    dev = {
      instance_types = ["t3.medium"] # t2.small might be too small

      min_size     = 1
      max_size     = 3
      desired_size = 2

      # Enable detailed monitoring
      enable_monitoring = true

      # Use latest EKS optimized AMI
      ami_type = "AL2023_x86_64_STANDARD"

      tags = {
        environment = "dev"
      }
    }
  }
}