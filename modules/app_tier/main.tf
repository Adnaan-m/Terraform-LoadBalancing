provider "aws" {
  region                  = "eu-west-1"
}
resource "aws_instance" "app_adnaan" {
  ami                     = "${var.ami_id}"
  subnet_id               = "${aws_subnet.subnet_adnaan.id}"
  instance_type           = "t2.micro"
  vpc_security_group_ids  = ["${aws_security_group.app_security_group_adnaan.id}"]
  user_data               = "${var.user_data}"
  key_name                = "DevOpsStudents"
  tags {
    Name                  = "app_${var.name}"
  }
}
resource "aws_subnet" "subnet_adnaan" {
  vpc_id                  = "${var.vpc_id}"
  cidr_block              = "10.0.77.0/24"
  map_public_ip_on_launch = true
  tags {
    Name                  = "subnet_${var.name}"
  }
}
resource "aws_security_group" "app_security_group_adnaan" {
  name                    = "security_group_${var.name}"
  description             = "Inbound and outbound rules for the VPC of Kash"
  vpc_id                  = "${var.vpc_id}"
  ingress {
    from_port             = 80
    to_port               = 80
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }
  ingress {
    from_port             = 22
    to_port               = 22
    protocol              = "tcp"
    cidr_blocks           = ["0.0.0.0/0"]
  }
  egress {
    from_port             = 0
    to_port               = 0
    protocol              = "-1"
    cidr_blocks           = ["0.0.0.0/0"]
  }
  tags {
    Name                  = "security_group_${var.name}"
  }
}
resource "aws_route_table" "adnaan_route_table" {
  vpc_id                  = "${var.vpc_id}"
  route {
    cidr_block            = "0.0.0.0/0"
    gateway_id            = "${var.ig_id}"
  }
  tags {
    Name                  = "route_table_${var.name}"
  }
}
resource "aws_route_table_association" "adnaan-public-association" {
  subnet_id               = "${aws_subnet.subnet_adnaan.id}"
  route_table_id          = "${aws_route_table.adnaan_route_table.id}"
}
