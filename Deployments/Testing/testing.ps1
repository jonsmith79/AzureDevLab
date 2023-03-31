# Check if Az module is installed and import if not
if(Get-Module -Name Az.* -ListAvailable -ErrorAction SilentlyContinue){
    Write-Host -ForegroundColor DarkGreen "Az module(s) installed."
}else{
    Write-Host -ForegroundColor DarkRed "Az module is not installed, attempting to install."
    Install-Module -Name Az -Scope CurrentUser -Force
}

# Check if connected to Azure, and connect if not
if ($AzTenant = Get-AzContext -ErrorAction SilentlyContinue) {
    Write-Host -ForegroundColor DarkGreen "Connected to Azure tenant: $($AzTenant.Subscription.Name) ($($AzTenant.Tenant.Id))"
}else{
    Write-Host -ForegroundColor DarkRed "Not connected to Azure, please connect"
    Connect-AzAccount
}

# Check gallery image for latest Windows Server Core version of image
$locName="uksouth"
$pubName="MicrosoftWindowsServer"
$offerName="WindowsServer"
$skuName="2022-datacenter-azure-edition-core-smalldisk"

# Check gallery in Location for Publishers
Get-AzVMImagePublisher -Location $locName | Select-Object PublisherName

# Check gallery in Publishers for Offers
Get-AzVMImageOffer -Location $locName -PublisherName $pubName | Select-Object Offer

# Check gallery in Offers for Skus
Get-AzVMImageSku -Location $locName -PublisherName $pubName -Offer $offerName | Select-Object Skus

# Check gallery in Skus for Versions
Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Sku $skuName | Select-Object Version

# Check gallery for latest Version of image
Get-AzVMImage -Location $locName -PublisherName $pubName -Offer $offerName -Skus $skuName -Version Latest

