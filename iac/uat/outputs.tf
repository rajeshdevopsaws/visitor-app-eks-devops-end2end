output "endpoint" {
  value = aws_eks_cluster.visitor-eks.endpoint
}


output "Visitor-EKS-Cluster-Name" {
  value = aws_eks_cluster.visitor-eks.name
}

output "Visitor-EKS-WorkerNode-Role-Name" {
  value = aws_iam_role.visitor-eks-wn-role.name
}


