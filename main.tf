module "eks" {
  source          = "terraform-aws-modules/eks/aws"
  cluster_name    = "eks-cluster"
  subnet_ids      =  ["subnet-025d6f1d813b08c7b","subnet-059e8a4842b23e959", "subnet-00c5f78b8eea0e470","subnet-08e575e13d153eb1b"]
  vpc_id          = "vpc-0abb2b310159b3205"
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
  cluster_name = "eks-cluster"

  # subnet_ids      =  ["subnet-00c5f78b8eea0e470","subnet-0b705c64876c16c9f"]
  subnet_ids      =  ["subnet-00c5f78b8eea0e470","subnet-08e575e13d153eb1b"]
  selectors = [{
    namespace = "kube-system",labels:{ "eks.amazonaws.com/component"="coredns","k8s-app"="kube-dns", "app.kubernetes.io/instance"="aws-load-balancer-controller","app.kubernetes.io/name"="aws-load-balancer-controller", 
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
  cluster_name = "eks-cluster"

  subnet_ids      =  ["subnet-00c5f78b8eea0e470","subnet-08e575e13d153eb1b"]
  selectors = [{
    namespace = "game-2048",labels:{"app.kubernetes.io/name":"app-2048"}}]

  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}





