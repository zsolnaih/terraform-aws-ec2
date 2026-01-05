# Terraform AWS EC2 Module

This Terraform module provisions an **AWS EC2 instance** with a flexible configuration and **optional AWS Systems Manager (SSM) access**.

If requested, the module automatically creates and attaches an **IAM role and instance profile** required for SSM access.  
Alternatively, an **existing instance profile** can be reused.

---

## Features

- Creates a single EC2 instance
- Automatically selects the **latest Amazon Linux AMI**
- Optional:
  - Create and attach an **SSM IAM role + instance profile**
  - Or attach an **existing instance profile**
- Fully configurable instance parameters (type, subnet, security groups, tags, etc.)
- Exposes the created instance and instance profile as outputs

---

## Requirements

| Name | Version |
|-----|--------|
| Terraform | >= 1.10.0 |
| AWS Provider | ~> 6.26 |

---

## Modules

No modules.

---

## Resources

| Name | Type |
|------|------|
| [aws_iam_instance_profile.ssm_profile](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_instance_profile) | resource |
| [aws_iam_role.ssm_role](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role) | resource |
| [aws_iam_role_policy_attachment.ssm_role_attach](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role_policy_attachment) | resource |
| [aws_instance.this](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/instance) | resource |
| [aws_ami.linux](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/data-sources/ami) | data source |

---

## Inputs variables

| Name               | Description                                                                          | Type           | Default      | Required |
| ------------------ | ------------------------------------------------------------------------------------ | -------------- | ------------ | -------- |
| `name`             | Name assigned to the EC2 instance and related AWS resources                          | `string`       | `zsolnaih`   | no       |
| `ami`              | Custom AMI ID to use. If null, the latest Amazon Linux AMI is selected automatically | `string`       | `null`       | no       |
| `instance_type`    | EC2 instance type (e.g. `t3.micro`)                                                  | `string`       | `null`       | yes      |
| `ssm_managed`      | Whether to create and attach an IAM role for AWS Systems Manager access              | `bool`         | `true`       | no       |
| `subnet_id`        | Subnet ID where the EC2 instance will be launched                                    | `string`       | `null`       | yes      |
| `sg`               | List of security group IDs attached to the instance                                  | `list(string)` | `null`       | no       |
| `instance_profile` | Existing IAM instance profile name. If set, no SSM role is created                   | `string`       | `null`       | no       |
| `user_data_base64` | Base64-encoded user data script to be passed to the EC2 instance at launch. If null, no user data is applied.| `string`       | `null`       | no       |

---

## Outputs

| Name                    | Description                                                                                                                                                                             |
| ----------------------- | --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| `instance`              | The full `aws_instance` resource object created by the module.                                                                                                                          |
| `instance_profile_name` | Name of the IAM instance profile attached to the EC2 instance. Returns the SSM-managed profile if created, otherwise the user-provided instance profile, or `null` if none is attached. |

## SSM IAM resources

When the module is configured with:

- `ssm_managed = true`
- `instance_profile = null`

it automatically creates the IAM resources required for **AWS Systems Manager (SSM)** access and attaches them to the EC2 instance.

---

### IAM Role

- **Name:** `ssm_role`
- **Purpose:** Enables the EC2 instance to be managed via AWS Systems Manager

**Assume role (trust) policy:**

```json
{
  "Version": "2008-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```
This trust policy allows the EC2 service to assume the role.

**Attached policy**

The following AWS-managed policy is attached to the role:
- AmazonSSMManagedInstanceCore

**IAM Instance Profile**

- Name: ssm_profile
- Attached role: ssm_role
The instance profile is automatically associated with the EC2 instance created by the module.

**Behavior summary**

- IAM resources are created only when the module manages SSM access
- Providing an instance_profile disables IAM resource creation
- The EC2 instance will always reference exactly one instance profile