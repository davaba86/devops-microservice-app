# DevOps Microservice Application

## Design Overview

This projects aims to showcase a simple case where we have a Docker application which needs to communicate with an external database.

The infrastructure is provisioned on AWS, using Terraform (Infrastructure as Code).

On top the VM's will be provisioned through Ansible (Configuration Management) which also triggers Docker Compose. SSH keys are generated automatically and copied over to the VM's so there's no need to run any manual commands before.

The only thing required is to setup your AWS account so you can run `aws configure` to setup your authentication to AWS CLI.

One of the main goals was also to make use of the official Terraform AWS Modules as much as possible. This would allow you to focus more on the application instead of reinventing the wheel again.

Note! The sample applucation I'm using is not created by me and any credit and thanks should be given to the creator: <https://docs.docker.com/get-started/08_using_compose/>

## How to Use

1. Setup your own account in AWS, run `aws configure` to setup authentication.
2. Deploy Terraform project.

   ```bash
   cd iac
   terraform init
   terraform apply --auto-approve
   ```

The whole process takes around 7-10 minutes to fully be working.

## Verification

Verify SSH access to VM's.

```bash
cd iac
ssh -i ec2_key.pem ec2-user@PUBLIC_IP_ADDRESS
```

Verify Ansible connectivity to VM's.

```bash
cd cm
ansible -m ping web_servers
```

Finally to verify access through the ELB, take the a-record presented in the Terraform output and open ut in your browser.

If you see the simple application loaded correctly then you're there!

## Cleanup

Finally when you're done, don't forget to remove all your infrastructure to avoid any costs.

```bash
cd iac
terraform destroy --auto-approve
```

The whole process takes around 7-10 minutes before all infrastructure is fully terminated.
