## [v0.2.0] - 2026-01-05

### Added
- Added userdata filebase64 option

---

## [v0.1.0] - 2026-01-05

### Added
- Initial Terraform module for provisioning a single AWS EC2 instance
- Support for custom AMI or automatic selection of the latest Amazon Linux AMI
- Optional AWS Systems Manager (SSM) integration:
  - Automatic IAM role and instance profile creation
  - Attachment of `AmazonSSMManagedInstanceCore` policy
- Support for using an existing IAM instance profile
- Configurable networking options:
  - Subnet ID
  - Security group list
- Module outputs:
  - Full EC2 instance resource
  - Resolved instance profile name (SSM-managed or existing)