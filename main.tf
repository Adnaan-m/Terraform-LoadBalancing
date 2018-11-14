provider "aws" {
  region                  = "eu-west-1"
}
# resource "aws_internet_gateway" "default" {
#   vpc_id                  = "${var.vpc_id}"
#   internet_gateway_id  = "igw-08bc9b3838ff3ddf3"
#   tags {
#     Name                  = "Internet Gateway"
#   }
# }
data "template_file" "app_init" {
  template                = "${file("./scripts/app/init.sh.tpl")}"
  vars {
    db_host               = "mongodb://${module.db.adnaan_db}:27017/posts"
  }
}
data "template_file" "db_init" {
  template                = "${file("./scripts/db/init.sh.tpl")}"
}

# LOAD BALANCING STUFF

resource "aws_lb" "adnaan-lb" {
  name                    = "adnaan-lb"
  internal                = false
  load_balancer_type      = "network"
  subnets                 = ["${module.app.subnet_id}"]

  enable_deletion_protection = false

  tags {
    Environment           = "production"
  }
}
resource "aws_launch_configuration" "adnaan_launch_config" {
  name                    = "adnaan_launch_config"
  image_id                = "${var.app_ami_id}"
  instance_type           = "t2.micro"
  user_data               = "${data.template_file.app_init.rendered}"
}
resource "aws_launch_template" "adnaan_launch_template" {
  name_prefix             = "adnaan_launch_template"
  image_id                = "${var.app_ami_id}"
  instance_type           = "t2.micro"
}
resource "aws_autoscaling_group" "adnaan_autoscaling_group" {
  name                    = "adnaan_autoscaling_group"
  availability_zones      = ["eu-west-1a"]
  desired_capacity        = 1
  max_size                = 1
  min_size                = 1

  launch_template = {
    id                    = "${aws_launch_template.adnaan_launch_template.id}"
    version               = "$$Latest"
  }
  tags = [{
    key                   = "Name"
    value                 = "adnaan-instance"
    propagate_at_launch   = true
    }]
  }

  resource "aws_lb_target_group" "Adnaan_listener" {
    name = "26-06"
    port = 80
    protocol = "TCP"
    vpc_id = "${var.vpc_id}"
    stickiness {
   type = "lb_cookie"
   enabled = false
  }
  }
#
  resource "aws_alb_listener" "Adnaan_listener" {
    load_balancer_arn = "${aws_lb.adnaan-lb.arn}"
    port              = "80"
    protocol          = "TCP"
    default_action {
      type             = "forward"
      target_group_arn = "${aws_lb_target_group.Adnaan_listener.arn}"
    }
  }

  # MODULE STUFF

  module "app" {
    source                  = "./modules/app_tier"
    vpc_id                  = "${var.vpc_id}"
    name                    = "app-adnaan"
    ami_id                  = "${var.app_ami_id}"
    ig_id                   = "${var.ig_id}"
    user_data               = "${data.template_file.app_init.rendered}"
  }

  module "db" {
    source                  = "./modules/db_tier"
    vpc_id                  = "${var.vpc_id}"
    name                    = "adnaan_db"
    ami_id                  = "${var.db_ami_id}"
    ig_id                   = "${var.ig_id}"
    user_data               = "${data.template_file.db_init.rendered}"
  }
