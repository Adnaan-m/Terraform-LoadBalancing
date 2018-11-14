variable "vpc_id" {
  default = "vpc-02ee46f22955a5b81"
}
variable "ig_id" {
  description = "the ig to add to route tables"
}
variable "name" {
  default = "Adnaan"
}
variable "ami_id" {
  default = "ami-055c1755b888344f7"
}
variable "user_data" {
  description = "user data"
  default = ""
}
