
# Active Directory Single-Site

[![ADDS-Single-Site](https://github.com/jonsmith79/AzureDevLab/actions/workflows/ADDS-Single-Site.yml/badge.svg)](https://github.com/jonsmith79/AzureDevLab/actions/workflows/ADDS-Single-Site.yml)
![Active Directory Single Site](../xx_Images/ActiveDirectorySingleSite.png "ADDS Single Site")

This templates deploys:

- 1 - Resource Group
- 1 - Virtual Network
- 5 - Subnets
  - Gateway Subnet
  - Bastion Subnet
  - Tier 0 (Infrastructure) Subnet
  - Tier 1 (Data) Subnet
  - Tier 2 (Apps) Subnet
  - Tier 3 (Web) Subnet
  - Tier 4 (Client) Subnet
- 1 - NSG for ADDS traffic on Tier 0 subnet
- 1 - Azure Policy Initiative assignment of 'Deploy prerequisites to enable Guest Configuration policies on virtual machines' [^1] [^2]
- 1 - Domain Controller
- 1 - Guest Configuration Extension for the first Domain Controller
- ~~1 - Active Directory Forest/Domain~~
- ~~1 - Domain Joined Windows Workstation (Windows 11/10/7)~~

The deployment leverages Desired State Configuration scripts to further customize the following:

AD OU Structure:

- [domain.com]
    - Accounts
        * End User
            * Office 365
            * Non-Office 365
        * Admin
        * Service
    - Groups
        * End User
        * Admin
    - Servers
        * Servers2012R2
        * Serverrs2016
        * Servers2019
        * Servers2022
    - MaintenanceServers
    - MaintenanceWorkstations
    - Workstations
        * Windows11
        * Windows10
        * Windows7

Parameters that support changes
| Parameter | Description |
|-----------|-------------|
| namingConvention | Enter a name that will be used as a naming prefix for (Servers, VNets, etc) you are using. |
| Location | Set the location for resources. |
| Vnet1ID | Enter first 2 octets of your desired Address Space for Virtual Network 1 (Example:  10.1). |
| TimeZone | Select an appropriate Time Zone. |
| AutoShutdownEnabled | Yes = AutoShutdown Enabled, No = AutoShutdown Disabled. |
| AutoShutdownTime | 24-Hour Clock Time for Auto-Shutdown (Example: 1900 = 7PM). |
| AutoShutdownEmail | Auto-Shutdown notification Email (Example:  user@domain.com). |
| adminUsername |  Enter a valid Admin Username. |
| adminPassword | Enter a valid Admin Password. |
| WindowsServerLicenseType | Choose Windows Server License Type (Example:  Windows_Server or None). |
| vmDC1OSVersion | Select 2022-Datacenter (Windows 2022), 2019-Datacenter (Windows 2019), 2016-Datacenter (Windows 2016) or 2012-R2-Datacenter (Windows 2012 R2) Domain Controller 1 OS Version. |
| vmDC1VMSize | Enter a Valid VM Size based on which Region the VM is deployed. |
| --- | --- |
| WindowsClientLicenseType | Choose Windows Client License Type (Example:  Windows_Client or None). |
| Sub DNS Domain | OPTIONALLY, enter a valid DNS Sub Domain. (Example:  sub1. or sub1.sub2.    This entry must end with a DOT ). |
| Sub DNS BaseDN | OPTIONALLY, enter a valid DNS Sub Base DN. (Example:  DC=sub1, or DC=sub1,DC=sub2,    This entry must end with a COMMA ). |
| Net Bios Domain | Enter a valid Net Bios Domain Name (Example:  killerhomelab). |
| Internal Domain | Enter a valid Internal Domain (Exmaple:  killerhomelab). |
| InternalTLD | Select a valid Top-Level Domain using the Pull-Down Menu. |
| Reverse Lookup1 | Enter first 2 octets of your desired Address Space in Reverse (Example:  1.10). |
| WK1OSVersion | Select Windows-11, Windows-10 or Windows-7 Worksation 1 OS Version. |
| WK1VMSize | Enter a Valid VM Size based on which Region the VM is deployed. |

[^1]: Ensure the SPN has 'Owner' rights over the subscription and Azure AD Directory Read.All permissions. Further information available [here](https://techcommunity.microsoft.com/t5/azure-paas-blog/azure-policy-perform-policy-operations-through-azure-devops/ba-p/2045515#:~:text=By%20default%2C%20the%20SPN%20created%20by%20Azure%20DevOps,the%20Owner%20role%20assigned%20at%20the%20subscription%20level.).
[^2]: Ensure the 'Microsoft.GuestConfiguration' has been registered as a Resource Provider for the subscription. Further information available [here](https://learn.microsoft.com/en-us/azure/governance/machine-configuration/overview#resource-provider).
>*[Markdown Cheatsheet](https://www.markdown-cheatsheet.com/)*
