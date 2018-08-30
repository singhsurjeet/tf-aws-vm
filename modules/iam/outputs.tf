
#OUTPUTS

output "iam_instance_profile_box" {
  value = "${aws_iam_instance_profile.box-instance-profile.id}"
}
