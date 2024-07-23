## IRSA for cluster apps
variable "create_irsa_for_load_balancer_controller" {
  description = "Whether to create AWS Load balancer controller"
  type = bool
  default = true
}

variable "aws_region" {
  description = "The AWS region to use"
  type        = string
  default     = "us-east-1"
}

variable "aws_profile" {
  description = "The AWS CLI profile to use"
  type        = string
  default     = "default"
}

variable "cluster_name" {
  description = "The name of the EKS cluster"
  type        = string
  default     = "eks-cluster1"
}
