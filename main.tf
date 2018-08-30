

module "network" {
  source = "modules/network"

  region              = "${var.region}"
  cidr_block          = "${var.cidr_block}"
  environment         = "${var.environment}"
  availability_zones  = "${var.availability_zones}"
  public_subnet_cidr  = "${var.public_cidr_block}"
  //private_subnet_cidr = "${var.private_cidr_block}"
}

module "iam" {
  source = "./modules/iam"
}

module "master" {
  source = "modules/master"

  region          = "${var.region}"
  environment     = "${var.environment}"
  vpc_id          = "${module.network.vpc_id}"
  key_name        = "${var.key_name}"
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  iam_instance_profile_master = "${module.iam.iam_instance_profile_box}"
  public_subnet_id = "${module.network.vpc_public_subnet[0]}"
  component        = "master"
  desired          = "1"
  min              = "1"
  max              = "1"
}

module "etcd" {
  source = "modules/master"

  region          = "${var.region}"
  environment     = "${var.environment}"
  vpc_id          = "${module.network.vpc_id}"
  key_name        = "${var.key_name}"
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  iam_instance_profile_master = "${module.iam.iam_instance_profile_box}"
  public_subnet_id = "${module.network.vpc_public_subnet[1]}"
  component        = "etcd"
  desired          = "1"
  min              = "1"
  max              = "1"
}

module "worker" {
  source = "modules/master"

  region          = "${var.region}"
  environment     = "${var.environment}"
  vpc_id          = "${module.network.vpc_id}"
  key_name        = "${var.key_name}"
  ami             = "${var.ami}"
  instance_type   = "${var.instance_type}"
  iam_instance_profile_master = "${module.iam.iam_instance_profile_box}"
  public_subnet_id = "${module.network.vpc_public_subnet[2]}"
  component        = "worker"
  desired          = "2"
  min              = "2"
  max              = "2"
}