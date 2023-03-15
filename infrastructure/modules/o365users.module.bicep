
param connections_office365users_name string 
param connections_o365users_id string
param location string 

resource connections_office365users_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_office365users_name
  location: location
  kind: 'V1'
  properties: {
    statuses: [
      {
        status: 'Connected'
      }
    ]
    customParameterValues: {
    }
    nonSecretParameterValues: {
    }

    api: {
      name: connections_office365users_name
      displayName: 'Office 365 Users'
      description: 'Office 365 Users Connection provider lets you access user profiles in your organization using your Office 365 account. You can perform various actions such as get your profile, a user\'s profile, a user\'s manager or direct reports and also update a user profile.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1611/1.0.1611.3104/${connections_office365users_name}/icon.png'
      brandColor: '#eb3c00'
      id:connections_o365users_id
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/https://management.azure.com:443/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/connections/${connections_office365users_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}
output o365ConnectorID string = connections_office365users_name_resource.id
