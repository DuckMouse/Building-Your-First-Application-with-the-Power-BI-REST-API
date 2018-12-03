$appName = "PowerShell Test App"
$appURI = "http://localhost:4200"

$myApp = Get-AzureADApplication -Filter "DisplayName eq '$($appName)'"

$myApp.appId