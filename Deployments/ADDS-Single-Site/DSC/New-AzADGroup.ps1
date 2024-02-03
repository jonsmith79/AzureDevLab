# Test whether user is connected to Azure AD and if not connect
Connect-AzureAD

connect-graph -scopes "Group.ReadWrite.All"