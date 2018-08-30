//resource "aws_eip" "eip" {
//  vpc = true
//}

resource "aws_security_group" "sg" {
  name        = "${var.product}-${var.environment}-${var.component}-sg"
  vpc_id      = "${var.vpc_id}"
  description = "${var.component} security group"

  tags {
    Name = "${var.product}-${var.environment}-${var.component}-sg"
    KubernetesCluster= "${var.environment}"
    KubernetesClusterID = "${var.environment}"

  }
}

resource "aws_security_group_rule" "ingress" {
  type              = "ingress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = "${var.allowed_cidr}"
  ipv6_cidr_blocks  = "${var.allowed_ipv6_cidr}"
  security_group_id = "${aws_security_group.sg.id}"

}

//resource "aws_security_group_rule" "icmp_ingress" {
//  type              = "ingress"
//  from_port         = "8"
//  to_port           = "0"
//  protocol          = "icmp"
//  cidr_blocks       = "${var.allowed_cidr}"
//  security_group_id = "${aws_security_group.master.id}"
//}

resource "aws_security_group_rule" "egress" {
  type              = "egress"
  from_port         = "0"
  to_port           = "0"
  protocol          = "-1"
  cidr_blocks       = ["0.0.0.0/0"]
  ipv6_cidr_blocks  = ["::/0"]
  security_group_id = "${aws_security_group.sg.id}"
}

//data "template_file" "user_data" {
//  template = "${file("${path.module}/user_data.tpl")}"
//
//  vars {
//    //region     = "${var.region}"
//    //elastic_ip = "${aws_eip.eip.id}"
//  }
//}

resource "aws_launch_configuration" "lc" {
  name_prefix                 = "${var.product}-${var.environment}-lc-${var.component}-"
  key_name                    = "${var.key_name}"
  image_id                    = "${var.ami}"
  instance_type               = "${var.instance_type}"
  security_groups             = ["${aws_security_group.sg.id}"]
  associate_public_ip_address = "${var.associate_public_ip_address}"
  iam_instance_profile        = "${var.iam_instance_profile_master}"
  //user_data                   = "${data.template_file.user_data.rendered}"

  lifecycle {
    create_before_destroy = true
  }

}

resource "aws_autoscaling_group" "asg" {
  name                      = "${var.product}-${var.environment}-${var.component}"
  #vpc_zone_identifier       = ["${element(var.public_subnet_id, count.index)}"]
  vpc_zone_identifier       = ["${var.public_subnet_id}"]
  desired_capacity          = "${var.desired}"
  min_size                  = "${var.min}"
  max_size                  = "${var.max}"
  health_check_grace_period = "60"
  health_check_type         = "EC2"
  force_delete              = false
  wait_for_capacity_timeout = 0
  launch_configuration      = "${aws_launch_configuration.lc.name}"
  tag {
    key = "Name" value= "${var.product}-${var.environment}-${var.component}"
    propagate_at_launch =true
  }
  tag {
    key = "KubernetesCluster" value= "${var.environment}"
    propagate_at_launch =true
  }
  tag {
    key = "KubernetesClusterID" value= "${var.environment}"
    propagate_at_launch =true
  }

  lifecycle {
    create_before_destroy = true
  }
}