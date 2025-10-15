data "aws_iam_policy_document" "ec2_assume_role_policy" {
  statement {
    actions = [ "sts:AssumeRole" ]

    principals {
      type = "Service"
      identifiers = [ "ec2.amazonaws.com" ]
    }
  }
}

resource "aws_iam_role" "ec2_role" {
  name = "ec2-ecr-pull-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_assume_role_policy.json

  tags = {
    Name = "EC2 ECR Pull Role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_ecr_policy_attachment" {
    role = aws_iam_role.ec2_role.name
    policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryReadOnly"
}

resource "aws_iam_instance_profile" "ec2_instance_profile" {
  name = "ec2-ecr-pull-instance-profile"
  role = aws_iam_role.ec2_role.name
}