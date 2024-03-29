﻿configuration FIRSTDC
{
   param
   (
        [String]$TimeZone,        
        [String]$DomainName,
        [String]$NetBiosDomain,
        [System.Management.Automation.PSCredential]$Admincreds,
        [Int]$RetryCount=20,
        [Int]$RetryIntervalSec=30
    )

    Import-DscResource -ModuleName ActiveDirectoryDsc, xStorage, xNetworking, xPendingReboot, ComputerManagementDsc, xPSDesiredStateConfiguration, DNSServerDsc

    [System.Management.Automation.PSCredential]$DomainCreds = New-Object System.Management.Automation.PSCredential ("${NetBiosDomain}\$($Admincreds.UserName)", $Admincreds.Password)
    $Interface=Get-NetAdapter|Where-Object Name -Like "Ethernet*"|Select-Object -First 1
    $InterfaceAlias=$($Interface.Name)

    Node localhost
    {
        LocalConfigurationManager
        {
            RebootNodeIfNeeded = $true
        }

        WindowsFeature DNS
        {
            Ensure = "Present"
            Name = "DNS"
        }

        Script EnableDNSDiags
        {
      	    SetScript = {
                Set-DnsServerDiagnostics -All $true
                Write-Verbose -Verbose "Enabling DNS client diagnostics"
            }
            GetScript =  { @{} }
            TestScript = { $false }
            DependsOn = "[WindowsFeature]DNS"
        }

        WindowsFeature DnsTools
        {
            Ensure = "Present"
            Name = "RSAT-DNS-Server"
            DependsOn = "[WindowsFeature]DNS"
        }

        xWaitforDisk Disk2
        {
            DiskID = 2
            RetryIntervalSec =$RetryIntervalSec
            RetryCount = $RetryCount
        }

        xDisk ADDataDisk {
            DiskID = 2
            DriveLetter = "N"
            DependsOn = "[xWaitForDisk]Disk2"
        }

        WindowsFeature ADDSInstall
        {
            Ensure = "Present"
            Name = "AD-Domain-Services"
            DependsOn="[WindowsFeature]DNS"
        }

        WindowsFeature ADDSTools
        {
            Ensure = "Present"
            Name = "RSAT-ADDS-Tools"
            DependsOn = "[WindowsFeature]ADDSInstall"
        }

        WindowsFeature ADAdminCenter
        {
            Ensure = "Present"
            Name = "RSAT-AD-AdminCenter"
            DependsOn = "[WindowsFeature]ADDSTools"
        }

        ADDomain FirstDS
        {
            DomainName = $DomainName
            Credential = $DomainCreds
            SafemodeAdministratorPassword = $DomainCreds
            DomainNetBiosName = $NetBiosDomain
            ForestMode = "WinThreshold"
            DomainMode = "WinThreshold"
            DatabasePath = "N:\NTDS"
            LogPath = "N:\NTDS"
            SysvolPath = "N:\SYSVOL"
            DependsOn = @("[WindowsFeature]ADDSInstall", "[xDisk]ADDataDisk")
        }

        xDnsServerAddress DnsServerAddress
        {
            Address        = '127.0.0.1'
            InterfaceAlias = $InterfaceAlias
            AddressFamily  = 'IPv4'
            DependsOn = "[ADDomain]FirstDS"
        }

        TimeZone SetTimeZone
        {
            IsSingleInstance = 'Yes'
            TimeZone         = $TimeZone
        }

        Script UpdateDNSSettings
        {
            SetScript =
            {
                # Reset DNS
                Set-DnsClientServerAddress -InterfaceAlias "$using:InterfaceAlias" -ResetServerAddresses
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = "[xDnsServerAddress]DnsServerAddress"
        }

        Script IncreaseMaxEnvelopeSize
        {
            SetScript =
            {
                # Increase MaxEnvelopeSize
                #Set-ADDomainController -Identity $using:DomainName -MaxEnvelopeSize 10485760
                Set-Item -Path WSMan:\localhost\MaxEnvelopeSizeKb -Value 8192
            }
            GetScript =  { @{} }
            TestScript = { $false}
            DependsOn = "[Script]UpdateDNSSettings"
        }

        xPendingReboot RebootAfterPromotion{
            Name = "RebootAfterPromotion"
            DependsOn = "[Script]IncreaseMaxEnvelopeSize"
        }
    }
}