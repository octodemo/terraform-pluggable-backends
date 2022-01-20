
terraform {
  required_version = "~>1.1"
}

#
# backend is dynamically generated and injected by terragrunt
#

module "github" {
  source = "./modules/github"

  github_token = var.github_token
  owner        = var.github_owner
  repo_name    = var.github_repo_name
}


output "repository_url" {
  value       = module.github.repository_url
  description = "GitHub repository URL"
}

output "repository_full_name" {
  value       = module.github.repository_full_name
  description = "GitHub repository full name"
}