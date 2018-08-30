# Bastion IAM

data "aws_iam_policy_document" "assume-role-policy" {
  statement {
    actions = [
      "sts:AssumeRole",
    ]

    principals {
      type = "Service"

      identifiers = [
        "ec2.amazonaws.com",
      ]
    }
  }
}

resource "aws_iam_instance_profile" "box-instance-profile" {
  name = "box-instance-profile"
  path = "/"
  role = "${aws_iam_role.box-instance-role.name}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_role" "box-instance-role" {
  description        = "Managed by terraform"
  name               = "box-instance-role"
  assume_role_policy = "${data.aws_iam_policy_document.assume-role-policy.json}"

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_iam_policy" "box-instance-policy" {
  name   = "box-instance-policy"
  policy = "${file("${path.module}/policies/box_instance.json")}"
}

resource "aws_iam_policy_attachment" "box-ec2-fullaccess-policy-attach" {
  name       = "box-ec2-fullaccess-policy"
  roles      = ["${aws_iam_role.box-instance-role.id}"]
  policy_arn = "${aws_iam_policy.box-instance-policy.arn}"
}