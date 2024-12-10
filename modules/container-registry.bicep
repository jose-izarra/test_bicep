@description('Name of the Azure Container Registry')
param registryName string
@description('Location of the Azure Container Registry')
param location string = resourceGroup().location
@description('SKU for the Azure Container Registry')
param sku string = 'Standard'
param keyVaultResourceId string

#disable-next-line secure-secrets-in-params
param keyVaultSecretNameAdminUsername string
#disable-next-line secure-secrets-in-params
param keyVaultSecretNameAdminPassword0 string
#disable-next-line secure-secrets-in-params
param keyVaultSecretNameAdminPassword1 string

resource containerRegistry 'Microsoft.ContainerRegistry/registries@2023-07-01' = {
  name: registryName
  location: location
  sku: {
    name: sku
  }
  properties: {
    adminUserEnabled: true
  }
}

resource adminCredentialsKeyVault 'Microsoft.KeyVault/vaults@2021-10-01' existing = if (!empty(keyVaultResourceId)) {
  name: last(split((!empty(keyVaultResourceId) ? keyVaultResourceId : 'dummyVault'), '/'))!
}


// create a secret to store the container registry admin username
resource secretAdminUserName 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecretNameAdminUsername)) {
  name: !empty(keyVaultSecretNameAdminUsername) ? keyVaultSecretNameAdminUsername : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().username
}
}

// create a secret to store the container registry admin password 0
resource secretAdminUserPassword0 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecretNameAdminPassword0)) {
  name: !empty(keyVaultSecretNameAdminPassword0) ? keyVaultSecretNameAdminPassword0 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[0].value
}
}

// create a secret to store the container registry admin password 1
resource secretAdminUserPassword1 'Microsoft.KeyVault/vaults/secrets@2023-02-01' = if (!empty(keyVaultSecretNameAdminPassword1)) {
  name: !empty(keyVaultSecretNameAdminPassword1) ? keyVaultSecretNameAdminPassword1 : 'dummySecret'
  parent: adminCredentialsKeyVault
  properties: {
    value: containerRegistry.listCredentials().passwords[1].value
}
}

output registryLoginServer string = containerRegistry.properties.loginServer
