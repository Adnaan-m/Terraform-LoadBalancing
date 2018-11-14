output security_group_id {
  description = "the id of the app security group"
  value = "${aws_security_group.app_security_group_adnaan.id}"
}
output subnet_cidr_block {
  description = "the cidr block of the app subnet"
  value = "${aws_subnet.subnet_adnaan.cidr_block}"
}
output subnet_id {
  description = "the app subnet"
  value = "${aws_subnet.subnet_adnaan.id}"
}
