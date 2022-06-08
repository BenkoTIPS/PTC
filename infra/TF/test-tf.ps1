# Test-TF.ps1
## BUILD THE APP ZIP PACKAGE
# dotnet publish ..\..\myApp\myApp.csproj -c release  -r linux-x64 -o ..\..\publish
# compress-archive -Path ..\..\publish\* -DestinationPath ..\..\publish\myapp.zip -Force

## LOGIN TO AZURE
# az login
# az account set --s fy22-mvp-imademo
# az account show

## PowerShell Vars
del .\terraform*
rm -r .terraform*

terraform init # -backend-config="backend.tfvars"

terraform plan -var-file params.du22.tfvars 

terraform apply -var-file params.du22.tfvars -auto-approve

## Outputs
$tf_site_name = terraform output site_name
$tf_rg_name = terraform output rg_name


## az webapp deploy --resource-group $rg --name $outputs.siteName.value --src-path ..\..\Publish\myApp.zip
az webapp deployment source config-zip --resource-group $tf_rg_name --name $tf_site_name --src ..\..\Publish\myApp.zip


terraform destroy -var-file params.$env.tfvars

