/*-------------------------------------------------------------------------------------------
  Parameters section
-------------------------------------------------------------------------------------------*/
@description('End User Device (EUD) name')
param eudName string

@description('ADDS NetBIOS Domain Name')
param eudNetBIOSDomain string

@description('End User Device (EUD) location')
param eudLocation string = resourceGroup().location

@description('End User Device (EUD) FQDN of the AD domain to join')
param eudDomainFQDN string

@description('End User Device (EUD) username to join the AD domain')
param eudDomainUsername string

@description('End User Device (EUD) password to join the AD domain')
@secure()
param eudDomainPassword string

@description('End User Device (EUD) OU to join the AD domain')
param eudDomainOU string

@description('Set of bit flags that define the join options. Default value of 3 is a combination of NETSETUP_JOIN_DOMAIN (0x00000001) & NETSETUP_ACCT_CREATE (0x00000002) i.e. will join the domain and create the account on the domain. For more information see https://msdn.microsoft.com/en-us/library/aa392154(v=vs.85).aspx')
param domainJoinOptions int = 3

/*-------------------------------------------------------------------------------------------
  Variables section
-------------------------------------------------------------------------------------------*/

/*-------------------------------------------------------------------------------------------
  Resources section
-------------------------------------------------------------------------------------------*/
resource computerName_DomainJoin 'Microsoft.Compute/virtualMachines/extensions@2022-11-01' = {
  name: '${eudName}/DomainJoin'
  location: eudLocation
  properties: {
    publisher: 'Microsoft.Compute'
    type: 'JsonADDomainExtension'
    typeHandlerVersion: '1.3'
    autoUpgradeMinorVersion: true
    settings: {
      name: eudDomainFQDN
      options: domainJoinOptions
      user: '${eudNetBIOSDomain}\\${eudDomainUsername}'
      ouPath: eudDomainOU
      restart: true
    }
    protectedSettings: {
      password: eudDomainPassword
    }
  }
}

/*-------------------------------------------------------------------------------------------
  Outputs section
-------------------------------------------------------------------------------------------*/
