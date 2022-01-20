variable "owner" {
  type        = string
  default     = "octodemo"
  description = "The owner of the repository to be created"
}

variable "repo_name" {
  type        = string
  default     = "terraform-test"
  description = "The name of the repository to be created"
}

variable "github_token" {
  type        = string
  description = "The GitHub Access Token (PAT) that can create repositories in the specified owner location."
}