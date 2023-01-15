@description('Time Zone')
param adlTimeZone string = 'UTC'

@description('Enable Auto Shutdown')
param adlAutoShutdown bool = false

@description('Auto Shutdown Time')
param adlAutoShutdownTime string = '19:00'

@description('Auto Shutdown Email')
param adlAutoShutdownEmail string = 'jon@smith365.uk'

@description('Enable Auto Start')
param adlAutoStart bool = false

@description('Auto Start Time')
param adlAutoStartTime string = '07:00'

@description('Auto Start Email')
param adlAutoStartEmail string = 'jon@smith365.uk'

@description('Name of the Administrator of the new VM and Domain')
param adlAdminUsername string = 'adlAdmin'

@description('Password for the new VM and Domain')
@secure()
param adlAdminPassword string

@description('Windows Server OS Licence Type')
param adlWindowsServerLicenceType string

@description('Windows Client OS Licence Type')
param adlWindowsClientLicenceType string

