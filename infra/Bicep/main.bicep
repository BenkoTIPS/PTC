param appName string
param envName string
param color string
@secure()
param secretValue string

targetScope = 'subscription'

resource rg 'Microsoft.Resources/resourceGroups@2021-04-01' = {
  name: 'bnk-${appName}-${envName}-rg'
  location: 'centralus'
}

module site 'mywebsite.bicep' = {
  scope: resourceGroup(rg.name)
  name:  deployment().name
  params: {
    appName: appName
    envName: envName
    secretValue: secretValue
    color: color
  }
}

output rgName string = rg.name
