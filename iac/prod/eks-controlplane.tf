resource "aws_eks_cluster" "visitor-eks" {
  name     = local.cluster_name
  role_arn = aws_iam_role.visitor-role.arn

  vpc_config {
    subnet_ids = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  }


  # Ensure that IAM Role permissions are created before and deleted after EKS Cluster handling.
  # Otherwise, EKS will not be able to properly delete EKS managed EC2 infrastructure such as Security Groups.
  depends_on = [
    aws_iam_role_policy_attachment.visitor-AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.visitor-AmazonEKSVPCResourceController,
    aws_iam_role_policy.policyelbpermissions,
    aws_iam_role_policy.policycloudWatchmetrics
  ]
  tags = {
    "Name" = "visitor-eks-cluster"
  }
}


