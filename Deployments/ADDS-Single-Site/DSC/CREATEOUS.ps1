configuration CREATEOUs
{
   param
   (
        [String]$BaseDN
    )

    Import-DscResource -Module ActiveDirectoryDsc

    Node localhost
    {

        ADOrganizationalUnit AccountsOU
        {
            Name                            = "Accounts"
            Path                            = "$BaseDN"
            Description                     = "Accounts OU"
            Ensure                          = 'Present'
        }

        ADOrganizationalUnit ServersOU
        {
            Name                            = "Servers"
            Path                            = "$BaseDN"
            Description                     = "Servers OU"
            Ensure                          = 'Present'
        }


        ADOrganizationalUnit ClientsOU
        {
            Name                            = "Clients"
            Path                            = "$BaseDN"
            Description                     = "Clients OU"
            Ensure                          = 'Present'
        }

        ADOrganizationalUnit GroupsOU
        {
            Name                            = "Groups"
            Path                            = "$BaseDN"
            Description                     = "Groups OU"
            Ensure                          = 'Present'
        }

        ADOrganizationalUnit UsersOU
        {
            Name                            = "Users"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Users OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]AccountsOU"
        }

        ADOrganizationalUnit AdminsOU
        {
            Name                            = "Admins"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Admins OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]AccountsOU"
        }

        ADOrganizationalUnit ServiceOU
        {
            Name                            = "Service"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Service OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]AccountsOU"
        }

        ADOrganizationalUnit InfraOU
        {
            Name                            = "Infra"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Infrastructure Servers OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ServersOU"
        }

        ADOrganizationalUnit DataOU
        {
            Name                            = "Data"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Data Servers OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ServersOU"
        }

        ADOrganizationalUnit AppsOU
        {
            Name                            = "Apps"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Application Servers OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ServersOU"
        }

        ADOrganizationalUnit WebOU
        {
            Name                            = "Web"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Web Servers OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ServersOU"
        }

        ADOrganizationalUnit WindowsOU
        {
            Name                            = "Windows"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Windows Clients OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ClientsOU"
        }

        ADOrganizationalUnit iOSOU
        {
            Name                            = "iOS"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "iOS Clients OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ClientsOU"
        }

        ADOrganizationalUnit iPadOSOU
        {
            Name                            = "iPadOS"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "iPadOS Clients OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ClientsOU"
        }

        ADOrganizationalUnit AndroidOU
        {
            Name                            = "Android"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Android Clients OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ClientsOU"
        }

        ADOrganizationalUnit macOSOU
        {
            Name                            = "macOS"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "macOS Clients OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]ClientsOU"
        }

        ADOrganizationalUnit SecurityOU
        {
            Name                            = "Security"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Security Groups OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]GroupsOU"
        }

        ADOrganizationalUnit DistributionOU
        {
            Name                            = "Distribution"
            Path                            = "OU=Accounts,$BaseDN"
            Description                     = "Distribution Groups OU"
            Ensure                          = 'Present'
            DependsOn = "[ADOrganizationalUnit]GroupsOU"
        }

    }
}