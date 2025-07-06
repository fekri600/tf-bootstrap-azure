.ONESHELL:
.SHELLFLAGS = -e -o pipefail -c
ENVIRONMENTS = staging production

deploy-bootstrap:
	@echo " Saving Azure subscription & tenant IDs..."
	cd bootstrap && az account show --query id            -o tsv > outputs/.subscription_id
	cd bootstrap && az account show --query tenantId       -o tsv > outputs/.tenant_id

	@echo " Generating Backend providers.tf..."
	bash scripts/generate_backend_provider.sh

	@echo " Deploying bootstrap ..."
	cd bootstrap && terraform init && terraform apply -auto-approve

	@echo " Saving backend details..."
	cd bootstrap && terraform output -raw resource_group_name    > outputs/.backend_rg
	cd bootstrap && terraform output -raw storage_account_name    > outputs/.backend_sa
	cd bootstrap && terraform output -raw container_name          > outputs/.backend_container
	cd bootstrap && echo 'terraform/state.tfstate'                > outputs/.key

	@echo " Saving oidc details..."
	cd bootstrap && terraform output -raw app_id                  > outputs/.github_app_id
	cd bootstrap && terraform output -raw service_principal_id    > outputs/.github_sp_id
	cd bootstrap && terraform output -raw resource_group_name     > outputs/rg.tex

	@echo " Generating providers.tf..."
	bash scripts/generate_provider_file.sh

	@echo "✅ Apply completed."

	@echo " Setting GitHub secrets..."
	@cd bootstrap && \
	  gh secret set AZURE_CLIENT_ID       --body "$$(cat outputs/.github_app_id)" && \
	  gh secret set AZURE_TENANT_ID       --body "$$(cat outputs/.tenant_id)" && \
	  gh secret set AZURE_SUBSCRIPTION_ID --body "$$(cat outputs/.subscription_id)"
	  
delete-bootstrap:
	@echo " Destroying GitHub bootstrap infrastructure..."
	cd bootstrap && terraform destroy -auto-approve

	@echo " Cleaning up generated files..."
	rm -f bootstrap/outputs/.backend_rg \
	      bootstrap/outputs/.backend_sa \
	      bootstrap/outputs/.backend_container \
	      bootstrap/outputs/.key \
	      bootstrap/outputs/.github_app_id \
	      bootstrap/outputs/.github_sp_id \
	      bootstrap/outputs/.subscription_id \
	      bootstrap/outputs/.tenant_id

	@echo "✅ Delete completed."


