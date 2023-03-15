param connections_office365_name string 
param connections_o365_id string
param location string

resource connections_office365_name_resource 'Microsoft.Web/connections@2016-06-01' = {
  name: connections_office365_name
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
      name: connections_office365_name
      displayName: 'Office 365 Outlook'
      description: 'Microsoft Office 365 is a cloud-based service that is designed to help meet your organization\'s needs for robust security, reliability, and user productivity.'
      iconUri: 'https://connectoricons-prod.azureedge.net/releases/v1.0.1618/1.0.1618.3179/${connections_office365_name}/icon.png'
      brandColor: '#0078D4'
      id: connections_o365_id
      type: 'Microsoft.Web/locations/managedApis'
    }
    testLinks: [
      {
        requestUri: 'https://management.azure.com:443/subscriptions/${subscription().subscriptionId}/resourceGroups/${resourceGroup().name}/providers/Microsoft.Web/connections/${connections_office365_name}/extensions/proxy/testconnection?api-version=2016-06-01'
        method: 'get'
      }
    ]
  }
}
output o365ConnectorID string = connections_office365_name_resource.id
