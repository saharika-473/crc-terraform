variable "region" {
  type = string
  description = "The region where resource will be deployed as part of deployment of the Terraform configuration."
  default = "us-east-1"
}

variable "owner_acronym" {
  type = string
  description = "The acronym for the application / owner"
  default = "rahul"
}

variable "app_acronym" {
  type = string
  description = "The acronym for the application / project"
  default = "crc"
}

variable "region_acronym" {
  type = string
  description = "The acronym for the region where resource will be deployed."
  default = "use1"
}

variable "environment_acronym" {
  type = string
  description = "The acronym for the region where resource will be deployed."
  default = "dev"
}

variable "tags" {
  type = map(string)
  description = "A map of strings used to add tags during the deployment."
}

# S3 variables

variable "acl" {
  type = string
  description = "The canned ACL applied to the bucket."
  default = ""
}

variable "force_destroy" {
  type = bool
  description = <<EOT
  A boolean that indicates all objects (including any locaked objects) 
  should be deleted from the bucket so that the bucket can be destroyed without error. 
  These objects are not recoverable.
  EOT
  default = true
}