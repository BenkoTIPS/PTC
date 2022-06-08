# Test-Bicep.ps1

## BUILD THE APP ZIP PACKAGE
# dotnet publish ..\..\myApp\myApp.csproj -c release  -r linux-x64 -o ..\..\publish
# compress-archive -Path ..\..\publish\* -DestinationPath ..\..\publish\myapp.zip -Force

## LOGIN TO AZURE
# az login
# az account set --s fy22-mvp-imademo
# az account show


$appName = "du22"
$env = "bicep"
$today = Get-Date -Format 'MMddyy-hhmm'
$deploymentName = "bicep-cli-$today"
$templateFile = '.\main.bicep'
$paramFile = '.\bicep.parameters.json'
$rg = "$appName-$env-rg"

## Test original Bicep Module in a resource group
# az group create --name $rg --location centralus
# az deployment group create --resource-group $rg --template-file myWebSite.bicep --parameters bicep.parameters.json

az deployment sub create --name $deploymentName --location centralus --template-file main.bicep --parameters main.parameters.json

## OUTPUTS
$outputs=$(az deployment group show --name $deploymentName --resource-group $rg --query properties.outputs) | convertfrom-json
$bicep_site_name = $outputs.siteName.value
$bicep_rg_name = $outputs.rgName.value

## az webapp deploy --resource-group $rg --name $outputs.siteName.value --src-path ..\..\Publish\myApp.zip
az webapp deployment source config-zip --resource-group $bicep_rg_name --name $bicep_site_name --src ..\..\Publish\myApp.zip

