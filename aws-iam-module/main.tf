data "aws_iam_policy_document" "example" {
  statement {
    actions   = ["s3:PutObject", "s3:GetObject", "s3:CreateBucket", "s3:DeleteObject", "s3:DeleteBucket"]
    resources = ["*"]
    effect = "Allow"
    Condition = {
      "StringEquals" = {
        "aws:RequestedRegion" = "us-west-2"
    }
    }
  }
#   statement {
#     actions   = ["s3:*"]
#     resources = [aws_s3_bucket.bucket.arn]
#     effect = "Allow"
#   }
}

resource "aws_iam_policy" "policy" {
   name        = var.policy_name
   description = "My s3 test policy"
   policy = data.aws_iam_policy_document.example.json
}

data "aws_iam_policy_document" "assume_role" {
  statement {
    effect = "Allow"

    principals {
      type        = "Service"
      identifiers = ["ec2.amazonaws.com"]
    }

    actions = ["sts:AssumeRole"]
  }
}

resource "aws_iam_role" "role" {
  name               = var.role_name
  assume_role_policy = data.aws_iam_policy_document.assume_role.json
}

resource "aws_iam_role_policy_attachment" "test-attach" {
  role       = aws_iam_role.role.name
  policy_arn = aws_iam_policy.policy.arn
}
