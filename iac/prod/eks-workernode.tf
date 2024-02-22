resource "aws_eks_node_group" "visitor-eks-wn" {
  cluster_name    = aws_eks_cluster.visitor-eks.name
  node_group_name = "worker-group-1"
  node_role_arn   = aws_iam_role.visitor-eks-wn-role.arn
  subnet_ids      = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  instance_types  = ["t3.small"]

  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }

  update_config {
    max_unavailable = 1
  }
  tags = {
    Name = "ekswokerapp"
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.visitor-wn-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.visitor-wn-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.visitor-wn-AmazonEC2ContainerRegistryReadOnly,
  ]
}

resource "aws_eks_node_group" "visitor-eks-wn2" {
  cluster_name    = aws_eks_cluster.visitor-eks.name
  node_group_name = "worker-group-2"
  node_role_arn   = aws_iam_role.visitor-eks-wn-role.arn
  subnet_ids      = [aws_subnet.public-subnet1.id, aws_subnet.public-subnet2.id]
  instance_types  = ["t3.small"]
  
  scaling_config {
    desired_size = 1
    max_size     = 1
    min_size     = 1
  }


  update_config {
    max_unavailable = 1
  }
  tags = {
    Name = "ekswokerapp"
  }
  # Ensure that IAM Role permissions are created before and deleted after EKS Node Group handling.
  # Otherwise, EKS will not be able to properly delete EC2 Instances and Elastic Network Interfaces.
  depends_on = [
    aws_iam_role_policy_attachment.visitor-wn-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.visitor-wn-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.visitor-wn-AmazonEC2ContainerRegistryReadOnly,
  ]
}
