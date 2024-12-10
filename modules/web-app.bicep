@description('Name of the Azure Webapp for Linux Container')
param webappName string
@description('Location of the Azure Webapp for Linux Container')
param location string = resourceGroup().location
@description('Server Farm ID for the Azure Webapp for Linux Container')
param appServicePlanId string
@description('Container Registry Name for the Azure Webapp for Linux Container')
param containerRegistryName string
@description('Container Registry Image Name for the Azure Webapp for Linux Container')
param containerRegistryImageName string
@description('Container Registry Image Version for the Azure Webapp for Linux Container')
param containerRegistryImageVersion string

@description('Dcoker Registry Server URL for the Azure Webapp for Linux Container')
param dockerRegistryServerUrl string
@description('Dcoker Registry Server Username for the Azure Webapp for Linux Container')
@secure()
param dockerRegistryServerUsername string
@description('Dcoker Registry Server Password for the Azure Webapp for Linux Container')
@secure()
param dockerRegistryServerPassword string
@description('App settings for the Azure Webapp for Linux Container')

param appSettings object = {
  WEBSITES_ENABLE_APP_SERVICE_STORAGE: false
  DOCKER_REGISTRY_SERVER_URL: dockerRegistryServerUrl
  DOCKER_REGISTRY_SERVER_USERNAME: dockerRegistryServerUsername
  DOCKER_REGISTRY_SERVER_PASSWORD: dockerRegistryServerPassword
}


@description('Site config for the Azure Webapp for Linux Container')
param siteConfig object ={
  linuxFxVersion: 'DOCKER|${containerRegistryName}.azurecr.io/${containerRegistryImageName}:${containerRegistryImageVersion}'
  appCommandLine: ''
  appSettings: appSettings
}

resource webapp 'Microsoft.Web/sites@2021-02-01' = {
  name: webappName
  location: location
  properties: {
    serverFarmId: appServicePlanId
    siteConfig: siteConfig
  }
}

output appServiceAppHostName string = webapp.properties.defaultHostName
