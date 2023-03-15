@description('Location for all resources.')
param location string
@description('Base name that will appear for all resources.') 
param baseName string = 'contoso'
@description('Three letter environment abreviation to denote environment that will appear in all resource names') 
param environmentName string = 'dev'

var connecterPath = '/subscriptions/${subscription().subscriptionId}/providers/Microsoft.Web/locations/${location}/managedApis'

var o365ConnectorObject = {
  id: '${connecterPath}/office365'
  name: 'office365Test'
}
var o365UsersConnectorObject = {
  id: '${connecterPath}/office365users'
  name: 'office365users'
}
targetScope = 'subscription'

var regionReference = {
  centralus: 'cus'
  eastus: 'eus'
  westus: 'wus'
  westus2: 'wus2'
}
var nameSuffix = '${baseName}-${environmentName}-${regionReference[location]}'
var resourceGroupName = 'rg-${nameSuffix}'

/* Since we are mismatching scopes with a deployment at subscription and resource at resource group
 the main.bicep requires a Resource Group deployed at the subscription scope, all modules will be at the Resourece Group scope
 */
resource resourceGroup 'Microsoft.Resources/resourceGroups@2021-04-01' ={
  name: resourceGroupName
  location: location
}

module o365Users './modules/o365users.module.bicep' = {
  name: 'o365UsersModule'
  scope: resourceGroup
  params: {
    location: location
    connections_office365users_name: o365UsersConnectorObject.name
    connections_o365users_id: o365UsersConnectorObject.id
    
  }

}
module o365 './modules/o365.module.bicep' = {
  name: 'o365Module'
  scope: resourceGroup
  params: {
    location: location
    connections_office365_name: o365ConnectorObject.name
    connections_o365_id: o365ConnectorObject.id
  }
}

module logicApp './modules/logicApp.module.bicep' = {
  name: 'logicAppModule'
  scope: resourceGroup
  params: {
    location: location
    o365Object: o365ConnectorObject
    o365ResourceID:o365.outputs.o365ConnectorID
    o365UsersObject: o365UsersConnectorObject
    o365UsersResourceID: o365Users.outputs.o365ConnectorID
    logicAppName: nameSuffix
  }

}
