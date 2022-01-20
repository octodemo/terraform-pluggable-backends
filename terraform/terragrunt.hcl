remote_state {
    backend         = "${get_env("TF_VAR_terraform_state_backend", "gcs")}"

    generate = {
        path        = "backend.generated.tf"
        if_exists   = "overwrite_terragrunt"
    }

    # Generate the backend parameters as per the cloud provider, defaulting to gcs
    config = jsondecode(
        templatefile("backend/${get_env("TF_VAR_terraform_state_backend", "gcs")}.json",
            {   
                github_repository_owner: "${get_env("TF_VAR_github_owner")}",
                github_repository_name: "${get_env("TF_VAR_github_repo_name")}",

                azure_storage_account_resource_group = "${get_env("TF_VAR_azure_storage_account_resource_group", "terraform_state")}",
                azure_storage_account_name = "${get_env("TF_VAR_azure_storage_account_name", "githubdemoterraform")}",

                gcp_bucket = "${get_env("TF_VAR_gcs_backend_storage_bucket", "terraform-default")}",
            }
        )
    )
}