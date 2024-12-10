@description('Name of the Azure App Service Plan')
param appServicePlanName string
@description('Location of the Azure App Service Plan')
param location string = resourceGroup().location
@description('SKU Object for the Azure App Service Plan')

param sku object = {
  capacity: 1
  family: 'B'
  name: 'B1'
  size: 'B1'
  tier: 'Basic'
}
@description('Kind of the App Service Plan')
param kind string = 'Linux'

resource appServicePlan 'Microsoft.Web/serverfarms@2021-02-01' = {
  name: appServicePlanName
  location: location
  sku: sku
  kind: kind
  properties: {
    reserved: true
  }
}

output appServicePlanId string = appServicePlan.id
output appServicePlanName string = appServicePlan.name
