output adnaan_db {
  description = "the db instance that is created"
  value = "${aws_instance.db_adnaan.private_ip}"
}
