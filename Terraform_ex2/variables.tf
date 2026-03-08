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


variable "instance_profile_name" {
  description = "Name of an existing IAM instance profile (must already exist). The profile should reference the role you want attached."
  type        = string
  default     = "web_instance_profile"
}

variable "key_name" {
  description = "Name of the SSH key pair to use for EC2 instances"
  type        = string
  default     = "Nithish-first"
}