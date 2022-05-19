# Terraform modules for AWS VPC, EC2, S3, IAM

## Requirements

| Name | Version |
|------|---------|
| terraform | >= 0.13 |
| hashicorp/aws | ~> 3.63 |

## Providers

| Name | Version |
|------|---------|
| hashicorp/aws | ~> 3.63 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| username | User name that would be created | `string` | no | yes |
| public\_key\_path | Public key path for the user | `string` | no | yes |
| aws\_access\_key\_id | AWS access key id | `string` | no | yes |
| aws\_secret\_access\_key | AWS secret access key | `string` | no | yes |
| aws\_folder\_id | AWS folder id | `string` | no | yes |
| aws\_zone | AWS default zone | `string` | eu-central-1 | no |
| project\_name | Project name | `string` | `project-1` | no |
| env\_name | Environment name | `string` | dev | no |

## Variable definitions

There is an example of how environment variables could be defined

> export TF_VAR_username=`whoami`
>
> export TF_VAR_public_key_path=`ls ~/.ssh/id_rsa.pub`

## Outputs

| Name | Description |
|------|-------------|
| compute\_instance\_external\_ip | The external IP address of the instance |
| compute\_instance\_internal\_ip | The internal IP address of the instance |
| s3\_sa\_user\_access\_key | Service account access key |

## Description

* It creates simple infrastructure for typical web application
* Created infrastructure would have:

    - Simple network
    - Instances for frontend and backend
    - Each compute instance may have additional disks
    - Public, Private buckets
    - Backup bucket can be created
    - Service account to manage buckets

## AWS security group rules

* SSH access is allowed from any ip to each instance
* Web ports(80, 443) are allowed from any ip for frontend instance
* All network interaction are allowed inside the local network