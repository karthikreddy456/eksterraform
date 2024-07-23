module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-cluster1"
  
  subnet_ids      = [""]
  vpc_id          = "vpc-xxxxxxxxxxxxxxxx"
  cluster_version = "1.29"
  # fargate_profile = {
  #   eks_cluster_name = "eks-fargate-cluster"
  #   subnets          = ["subnet-xxxxxxxxxxxxxxxxx", "subnet-yyyyyyyyyyyyyyyyy"]
  # }
} 

module "fargate-profile" {
  #source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  source = "D:/terraform/aws_eks/.terraform/modules/eks/modules/fargate-profile"

  name         = "separate-fargate-profile"
  cluster_name = "eks-cluster1"

  subnet_ids      =  [""]
  
  selectors = [{
    namespace = "kube-system",labels:{ "app.kubernetes.io/instance"="aws-load-balancer-controller","app.kubernetes.io/name"="aws-load-balancer-controller", 
}
},{namespace = "default"}]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "fargate-profile1" {
  #source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  source = "D:/terraform/aws_eks/.terraform/modules/eks/modules/fargate-profile"

  name         = "fargate-profile1"
  cluster_name = "eks-cluster1"

  subnet_ids      =  ["subnet-00c5f78b8eea0e470","subnet-08e575e13d153eb1b"]
  selectors = [{
    namespace = "game-2048",labels:{"app.kubernetes.io/name":"app-2048"}}]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

module "fargate-profile2" {
  #source = "terraform-aws-modules/eks/aws//modules/fargate-profile"

  source = "D:/terraform/aws_eks/.terraform/modules/eks/modules/fargate-profile"

  name         = "coredns"
  cluster_name = "eks-cluster1"

  subnet_ids      =  ["subnet-00c5f78b8eea0e470","subnet-08e575e13d153eb1b"]
  selectors = [{
    namespace = "kube-system",labels:{ "k8s-app"="kube-dns"}}]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

## This will add the config for this cluster in your local kubeconfig file
resource "null_resource" "kubectl-init" {
  provisioner "local-exec" {
    command = "aws eks --region ${var.aws_region} update-kubeconfig --name ${module.eks.cluster_name} --profile ${var.aws_profile}"
  }
  depends_on = [module.eks.cluster_id]
}
 

#----------------------------------------------------------
#----------------------------------------------------------
module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "~> 1.0" #ensure to update this to the latest/desired version

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn

  eks_addons = {
    coredns = {
      most_recent = true
      resolve_conflicts = "OVERWRITE"
    }
    kube-proxy = {
      most_recent = true
    }
  }

  enable_aws_load_balancer_controller    = true
  


  tags = {
    Environment = "dev"
  }
}





