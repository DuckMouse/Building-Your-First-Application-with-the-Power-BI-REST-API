$Credentials = Get-Credential 
Connect-AzureAD -Credential $Credentials 

$appName = "PowerShell Test App"
$appURI = "http://localhost:4200"

if(!($myApp = Get-AzureADApplication -Filter "DisplayName eq '$($appName)'" -ErrorAction SilentlyContinue))
{
    $myApp = New Get-AzureADApplication -DisplayName $appName -IdentifierUris $appURI
}