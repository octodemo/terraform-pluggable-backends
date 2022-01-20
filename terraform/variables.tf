variable "github_token" {
  type        = string
  sensitive   = true
  description = "GitHub Personal Access Token with Repository and Packages Access"
}

variable "github_owner" {
  type        = string
  description = "The GitHub owner of the repository"
}

variable "github_repo_name" {
  type        = string
  description = "The GitHub repository name"
}