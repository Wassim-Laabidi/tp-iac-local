name: Terraform Docker Deployment

on:
  push:
    branches:
      - main
  workflow_dispatch:

jobs:
  deploy:
    runs-on: ubuntu-latest
    env:
      TF_DIR: /home/runner/work/tp-iac-local/tp-iac-local
      LOCALTUNNEL_SUBDOMAIN: mynginxapp
      LOCALTUNNEL_PORT: 8080

    steps:
      - name: Checkout Repository
        uses: actions/checkout@v3

      - name: Setup Terraform
        uses: hashicorp/setup-terraform@v2
        with:
          terraform_version: 1.6.0

      - name: Terraform Init
        working-directory: ${{ env.TF_DIR }}
        env:
          TF_REGISTRY_CLIENT_ALLOW_UNVERIFIED_SIG: "true"
        run: terraform init

      - name: Terraform Plan
        working-directory: ${{ env.TF_DIR }}
        run: terraform plan -out=tfplan

      - name: Terraform Apply
        working-directory: ${{ env.TF_DIR }}
        run: terraform apply -auto-approve tfplan || terraform apply -auto-approve

      - name: Verify Docker Containers
        run: docker ps

      - name: Install LocalTunnel and Expose App
        run: |
          npm install -g localtunnel || true
          nohup lt --port ${{ env.LOCALTUNNEL_PORT }} --subdomain ${{ env.LOCALTUNNEL_SUBDOMAIN }} &
          echo "App publicly accessible at https://${{ env.LOCALTUNNEL_SUBDOMAIN }}.loca.lt"

