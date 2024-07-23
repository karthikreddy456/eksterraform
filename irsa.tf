# AWS Load Balancer Controller
module "load_balancer_controller_irsa_role" {
  count   = var.create_irsa_for_load_balancer_controller ? 1 : 0
  # source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  # version = "= 5.28.0"
  source = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
 
  role_name                              = "${module.eks.cluster_name}-load-balancer-controller-role"
  attach_load_balancer_controller_policy = true
 
  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:aws-load-balancer-controller-sa"]
    }
  }
 
}