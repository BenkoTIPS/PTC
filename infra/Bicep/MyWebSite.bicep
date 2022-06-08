param appName string
param color string = 'lightblue'
param envName string

@secure()
param secretValue string

var sitename_var = '${appName}-${envName}-web'
var hostName_var = '${appName}-${envName}-plan'
var location = resourceGroup().location

resource hostName 'Microsoft.Web/serverfarms@2020-12-01' = {
  name: hostName_var
  location: location
  kind: 'app,linux'
  sku: {
    name: 'S1'
    capacity: 1
  }
  tags: {
    displayName: hostName_var
  }
  properties: {
    reserved: true
  }
}

resource sitename 'Microsoft.Web/sites@2020-12-01' = {
  name: sitename_var
  location: location
  tags: {
    'hidden-related:${resourceGroup().id}/providers/Microsoft.Web/serverfarms/${hostName_var}': 'Resource'
    displayName: sitename_var
  }
  properties: {
    siteConfig: {
      linuxFxVersion: 'DOTNETCORE|6.0'
      appCommandLine: 'dotnet myApp.dll'
    }
    serverFarmId: hostName.id
  }
}

resource sitename_appsettings 'Microsoft.Web/sites/config@2015-08-01' = {
  parent: sitename
  name: 'appsettings'
  location: location
  tags: {
    displayName: 'config'
  }
  properties: {
    EnvName: envName
    FavoriteColor: color
    MySecret: secretValue
    WEBSITE_RUN_FROM_PACKAGE: 1
  }
}

output siteName string = sitename_var
output rgName string = resourceGroup().name