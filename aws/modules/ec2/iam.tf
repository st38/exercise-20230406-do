# IAM Role
resource "aws_iam_role" "this" {
  name_prefix = "${local.name}-"
  description = local.name
  path        = "/"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          Service = "ec2.amazonaws.com"
        }
      },
    ]
  })
}

# IAM Instance Profile
resource "aws_iam_instance_profile" "this" {
  name = aws_iam_role.this.name
  role = aws_iam_role.this.name
}

# IAM Policy
resource "aws_iam_role_policy" "this" {
  name = aws_iam_role.this.name
  role = aws_iam_role.this.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = [
          "ec2:DescribeInstances"
        ]
        Effect   = "Allow"
        Resource = "*"
      }
    ]
  })
}
