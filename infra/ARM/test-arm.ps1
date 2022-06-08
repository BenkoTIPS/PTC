# Test-ARM.ps1

## BUILD THE APP ZIP PACKAGE
dotnet publish ..\..\myApp\myApp.csproj -c release  -o ..\..\publish
compress-archive -Path ..\..\publish\* -DestinationPath ..\..\publish\myapp.zip -Force

## LOGIN TO AZURE
az login
az account show

## Set Vars
$appName = "du22"
$env = "arm"
$rg = "$appName-$env-rg"
$today = Get-Date -Format 'MMddyy-hhmm'
$deploymentName = "arm-cli-$today"
$templateFile = ".\myWebSite.json"
$paramFile    = ".\MyWebSite.parameters.json"

## Deploy RG and ARM Template
az group create --name $rg --location centralus

az deployment group create --name $deploymentName --resource-group $rg --template-file $templateFile --parameters $paramFile

## Outputs
$outputs=$(az group deployment show --name $deploymentName --resource-group $rg --query properties.outputs) | convertfrom-json
$arm_site_name = $outputs.siteName.value
$arm_rg_name = $outputs.rgName.value

## 
# az webapp deploy --resource-group $arm_rg_name --name $arm_site_name --src-path ..\..\Publish\myApp.zip
# az webapp config appsettings set --resource-group $arm_rg_name --name $arm_site_name --settings WEBSITE_RUN_FROM_PACKAGE="1"
az webapp deployment source config-zip --resource-group $arm_rg_name --name $arm_site_name --src ..\..\Publish\myApp.zip

## Decompile Bicep File from source ARM
az bicep decompile -f .\MyWebSite.json
