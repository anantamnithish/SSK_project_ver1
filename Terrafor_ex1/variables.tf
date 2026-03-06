variable "ami" {
  description = "This instance is used to launch a web server"
  type        = string
  default     = "ami-090b9c8aa1c84aefc"
}
variable "instance_type" {
  description = "we use t3 family as instance typre"
  type        = string
  default     = "t3.micro"
}