terraform {
  required_version = "~>1.1.3"

  required_providers {
    github = {
      source  = "integrations/github"
      version = "~>4.19.1"
    }
  }
}

provider "github" {
  # It is possible here to utilize the app_auth to authenticate as a GitHub Application, which has higher API limits
  token = var.github_token
  owner = var.owner
}


resource "github_repository" "repository" {
  name        = var.repo_name
  description = "Terraform provisioned repository"

  visibility = "internal"

  has_issues   = true
  has_projects = false

  allow_merge_commit = true
  allow_rebase_merge = false
  allow_auto_merge   = false

  license_template = "mit"
}

resource "github_team" "repository_admins" {
  name                      = "${github_repository.repository.name}-admins"
  description               = "Admins for the ${github_repository.repository.name} repository"
  create_default_maintainer = true
}

resource "github_team_repository" "repository_admins" {
  team_id    = github_team.repository_admins.id
  repository = github_repository.repository.name
  permission = "admin"
}

resource "github_branch_protection" "protect_default_branch" {
  repository_id  = github_repository.repository.name
  pattern        = "main"
  enforce_admins = true

  required_status_checks {
    strict   = false
    contexts = ["Build java 11 on ubuntu-20.04"]
  }
  required_pull_request_reviews {
    dismiss_stale_reviews           = true
    required_approving_review_count = 1
  }
}


output "repository_url" {
  value       = github_repository.repository.html_url
  description = "The URL to the repository that was created"
}

output "repository_full_name" {
  value       = github_repository.repository.full_name
  description = "The full name of the repository that was created"
}