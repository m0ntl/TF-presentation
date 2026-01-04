# Terraform CI/CD Pipeline Setup

This repository contains a GitHub Actions workflow that automates Terraform deployment with security scanning, testing, and cost analysis.

## Pipeline Stages

### Stage 1: Feature Branch Security Scans (On Push)
When you push to any feature branch:
- **Terrascan**: Scans for security vulnerabilities and compliance violations
- **Checkov**: Performs infrastructure-as-code security scanning

### Stage 2: PR Validation and Planning
When a PR is opened or updated:
- **Terraform Validate**: Validates Terraform configuration syntax
- **Terraform Test**: Runs any defined Terraform tests
- **Terraform Plan**: Creates execution plan and posts results to PR
- **Infracost**: Analyzes infrastructure costs and posts breakdown to PR

### Stage 3: Apply (Manual Approval Required)
After manual approval through GitHub Environment:
- **Terraform Apply**: Applies the planned changes using the saved plan file

## Required Configuration

### 1. GitHub Secrets
Add the following secrets to your repository (`Settings` → `Secrets and variables` → `Actions`):

```
AWS_ACCESS_KEY_ID          # AWS credentials for Terraform
AWS_SECRET_ACCESS_KEY      # AWS credentials for Terraform
INFRACOST_API_KEY          # Get free API key from https://www.infracost.io/
```

### 2. GitHub Environment Setup
Configure a protected environment for manual approvals:

1. Go to `Settings` → `Environments` → `New environment`
2. Name it: `production`
3. Add **Required reviewers** (select team members who can approve deployments)
4. Optionally set **Wait timer** for additional safety
5. Save protection rules

### 3. Repository Permissions
Ensure the following permissions are enabled:

1. `Settings` → `Actions` → `General` → `Workflow permissions`
   - ✅ Read and write permissions
   - ✅ Allow GitHub Actions to create and approve pull requests

2. `Settings` → `Code security and analysis`
   - ✅ Enable code scanning alerts

## Workflow Triggers

### Push to Feature Branch
```bash
git checkout -b feature/new-infrastructure
git add .
git commit -m "Add new resources"
git push origin feature/new-infrastructure
```
→ Triggers: Terrascan and Checkov scans

### Open Pull Request
```bash
gh pr create --base main --head feature/new-infrastructure
```
→ Triggers: Validate, Test, Plan, and Infracost jobs

### Manual Approval for Apply
1. Review the plan and cost analysis in PR comments
2. Go to the workflow run → `terraform-apply` job
3. Click **Review deployments**
4. Select `production` environment and click **Approve and deploy**

## Customization

### Adjust Terraform Version
Edit `.github/workflows/terraform-cicd.yml`:
```yaml
env:
  TF_VERSION: '1.6.0'  # Change to your version
```

### Change Working Directory
If your Terraform files are in a subdirectory:
```yaml
env:
  TERRAFORM_WORKING_DIR: './infrastructure'  # Change path
```

### Modify Security Scan Behavior
- **Terrascan**: Change `only_warn: true` to `only_warn: false` to fail on findings
- **Checkov**: Change `soft_fail: true` to `soft_fail: false` to fail on findings

## Pipeline Flow Diagram

```
Feature Branch Push
    ├── Terrascan Scan
    └── Checkov Scan

Pull Request Opened/Updated
    ├── Terraform Validate
    ├── Terraform Test
    ├── Terraform Plan ──────┐
    │   └── Post Plan to PR  │
    └── Infracost            │
        └── Post Cost to PR  │
                             │
Manual Approval Required     │
    │                        │
    └── Terraform Apply ─────┘
        └── Use Saved Plan
        └── Post Result to PR
```

## Troubleshooting

### Plan File Not Found in Apply
- Ensure the PR number matches between plan and apply stages
- Check artifact retention (default: 30 days)

### Infracost Not Working
- Verify `INFRACOST_API_KEY` is set correctly
- Check that Terraform backend is properly configured

### Apply Not Triggering
- Ensure `production` environment is configured with reviewers
- Check workflow permissions are set correctly

### Security Scans Only on Feature Branches
The workflow is designed to run security scans on pushes to non-main branches. To include main:
```yaml
on:
  push:
    branches:
      - '**'  # All branches including main
```

## Best Practices

1. **Always review** the Terraform plan before approving apply
2. **Check Infracost** to understand cost implications
3. **Address security findings** from Terrascan and Checkov
4. **Use descriptive branch names** for better tracking
5. **Keep plan artifacts** by adjusting retention-days if needed
6. **Test in staging** before applying to production
7. **Limit approvers** to senior team members or DevOps leads

## Additional Resources

- [GitHub Actions Documentation](https://docs.github.com/en/actions)
- [Terraform GitHub Actions](https://github.com/hashicorp/setup-terraform)
- [Infracost GitHub Action](https://github.com/infracost/actions)
- [Terrascan Documentation](https://runterrascan.io/)
- [Checkov Documentation](https://www.checkov.io/)
