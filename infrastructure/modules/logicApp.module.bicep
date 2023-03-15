param location string
param o365Object object
param o365ResourceID string
param o365UsersObject object
param o365UsersResourceID string
param logicAppName string

resource logicApp 'Microsoft.Logic/workflows@2019-05-01' = {
  name: 'la-${toLower(logicAppName)}'
  location: location
  tags: {
    customer: 'syneos'
  }
  properties: {
    state: 'Enabled'
    definition: {
      '$schema': 'https://schema.management.azure.com/providers/Microsoft.Logic/schemas/2016-06-01/workflowdefinition.json#'
      contentVersion: '1.0.0.0'
      parameters: {
        '$connections': {
          defaultValue: {
          }
          type: 'Object'
        }
      }
      triggers: {
        Recurrence: {
          recurrence: {
            frequency: 'Day'
            interval: 1
          }
          evaluatedRecurrence: {
            frequency: 'Day'
            interval: 1
          }
          type: 'Recurrence'
        }
      }
      actions: {
        Get_my_profile: {
          runAfter: {
          }
          type: 'ApiConnection'
          inputs: {
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'office365users\'][\'connectionId\']'
              }
            }
            method: 'get'
            path: '/users/me'
          }
        }
        Send_email: {
          runAfter: {
            Get_my_profile: [
              'Succeeded'
            ]
          }
          type: 'ApiConnection'
          inputs: {
            body: {
              Body: 'Hi @{body(\'Get_my_profile\')?[\'DisplayName\']}, you have a reminder!'
              Subject: '[Daily Reminder from Logic Apps]'
              To: '@{body(\'Get_my_profile\')?[\'Mail\']}'
            }
            host: {
              connection: {
                name: '@parameters(\'$connections\')[\'office365\'][\'connectionId\']'
              }
            }
            method: 'post'
            path: '/Mail'
          }
        }
      }
      outputs: {
      }
    }
    parameters: {
      '$connections': {
        value: {
          office365: {
            connectionId: o365ResourceID
            connectionName: o365Object.name
            id: o365Object.id
          }
          office365users: {
            connectionId: o365UsersResourceID
            connectionName: o365UsersObject.name
            id: o365UsersObject.id
          }
        }
      }
    }
  }
}
