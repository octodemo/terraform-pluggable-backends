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


## Using Azure backend

TODO

## Using GCP backend

TODO