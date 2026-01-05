variable "name" {
  description = "Name assigned to the EC2 instance."
  type = string
  default = "zsolnaih"
}

variable "ami" {
  description = "Custom AMI ID to use for the EC2 instance. As default, the latest Amazon Linux AMI is selected automatically."
  type = string
  default = null
}

variable "instance_type" {
  description = "EC2 instance type (e.g. t3.micro, t3.small)."
  type = string
}

variable "ssm_managed" {
  description = "Whether to create and attach an IAM role and instance profile for AWS Systems Manager (SSM) access."
  type = bool
  default = true
}

variable "subnet_id" {
  description = "Subnet ID where the EC2 instance will be launched."
  type = string
}

variable "sg" {
  description = "List of security group IDs to associate with the EC2 instance."
  type = list(string)
  default = null
}

variable "instance_profile" {
  description = "Existing IAM instance profile name to attach to the EC2 instance. If set, no SSM role will be created."
  type = string
  default = null
}

variable "user_data_base64" {
  description = "Base64-encoded user data script to be passed to the EC2 instance at launch. If null, no user data is applied."
  type = string
  default = null
}