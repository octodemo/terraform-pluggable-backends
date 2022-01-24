# terraform-pluggable-backends

This repository provides a way to switch between Azure or GCP state backends for Terraform.

To be able to switch backends we need to inject the backend configruation using Terragrunt to render the configuration
specifically to the desired cloud integration.
Secondly we are relying upon the default environment variables for the two cloud backends so that Terraform has the ability
to reference these and we can more dynamically inject then at run time (on the command line or via GitHub Actions).

## Terraform
The terraform IaC here is using the GitHub Terraform provider to create a repository and configure an access team specific to that repository.
We are also using the repository name to provide the ability to separate out the various terraform states that we will be storing on the specificed
cloud storage backend.

The terraform module is available from the [terraform](./terraform) directory.

### Terragrunt
The only reason for using Terragrunt here is to achieve the necessary injection of the storage configuration, which is an area that Terraform does not
yet provide complete variable injection support.

The [terraform/terragrunt.hcl](./terraform/terragrunt.hcl) file contains the remote backend configuration and will look up the corresponding JSON file
for the desired storage backend for the state ([`gcs.json`](./terraform/backend/gcs.json) for GCP and [`azurerm.json`](./terraform/backend/azurerm.json) for Azure).


## GitHub Actions Workflow

There is a [workflow](.github/workflowsterraform_apply.yml) that will configure access to the specifed state backend for Terraform as well as performing the 
necessary authentication with the backing cloud vendor before then using Terraform to create/update a GitHub repository.

To acheive this the terragrunt injection is used from the environment variables in effect when Terraform is executing to correctly link up to the backend. It is also
reliant the on the default environment variables that Terraform uses the cloud vendor when attempting to connect with the cloud resource 

There is a common GitHub Actions secret that is required to acces GitHub where the repository will be created:
- `GHEC_PROVISIONING_PAT`: the GitHub PAT that will be used to create the repository, it will need permissions to create repositories under the specified `owner`


### Using Azure backend

When using `azure` as the backend option for the Terraform worklfow you will need the following GitHub Actions Secrets defined;

- `ARM_CLIENT_ID`: the client id for the service principal
- `ARM_CLIENT_SECRET`: the client secret for the service principal
- `ARM_SUBSCRIPTION_ID`: the subscription id for the azure subscrition being accessed
- `ARM_TENANT_ID`: the tenant id for the azure subscription being accessed

### Using GCP backend

When using `gcp` as the backend option for the Terraform workflow you will need the following GitHub Actions Secrets defined;

- `GCP_PROJECT_ID`: the project id that hosts the GCS storage bucket
- `GCP_TERRAFORM_SERVICE_ACCOUNT_KEY`: the JSON key for the service account to authenicate and access the GCS storage bucket


### Using GitHub Actions Environments to separate secrets
By utilizing GitHub Actions Environments, the secrets relating to the target backends above can be isolated so that Azure related secrets are not shared with GCP related invocations and vice versa.

To do this an environment for each backend was created `azurerm` and `gcs` accordingly and the cloud specific secrets defined there.

![Screenshot 2022-01-24 at 17 01 56](https://user-images.githubusercontent.com/681306/150831195-e7e3a805-cc19-4fd6-88ee-b8345889e00c.png)
