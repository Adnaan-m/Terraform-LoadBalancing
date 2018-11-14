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
  default = "ami-052d4b45126cc68ec"
}
variable "user_data" {
  description = "user data"
  default = ""
}
