# Terraform bootstrap — remote state bucket

One-off module that creates the S3 bucket holding the root module's Terraform
state. It exists because of a chicken-and-egg problem: Terraform cannot create
its own state backend and store state in it during the same run.

Creates `terminal-app-tfstate-<ACCOUNT_ID>` with versioning, SSE-S3 encryption,
a full public-access block, and bucket-owner-enforced object ownership.

## Usage

Run once, before the root module's first `terraform init`:

```bash
cd terraform/bootstrap
terraform init
terraform apply
```

Then `cd ..` and run `terraform init -migrate-state` in the root module.

## State

This module keeps **local** state (`terraform/bootstrap/terraform.tfstate`,
gitignored). That is intentional — it has nowhere remote to put it. The state
holds only bucket configuration, no secrets.

If the local state is ever lost, the bucket can be re-adopted rather than
recreated:

```bash
terraform import aws_s3_bucket.tfstate terminal-app-tfstate-<ACCOUNT_ID>
```

## Teardown

Destroying this destroys the state bucket for the root module. Migrate the root
module back to local state first (`terraform init -migrate-state` with the
backend block removed), or you will orphan every resource it manages.
