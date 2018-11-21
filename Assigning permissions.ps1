$Credentials = Get-Credential 
Connect-AzureAD -Credential $Credentials 

$svcprincipalPbi = Get-AzureADServicePrincipal -All $true | ? { $_.DisplayName -match "Power BI Service" }
$svcprincipalAAD = Get-AzureADServicePrincipal -All $true | ? { $_.DisplayName -match "Windows Azure Active Directory" }

$svcprincipalPbi.AppRoles | FT ID, DisplayName
$svcprincipalAAD.AppRoles | FT ID, DisplayName
 
# Show the Delegated Permissions
$svcprincipalPbi.Oauth2Permissions | FT ID, UserConsentDisplayName
$svcprincipalAAD.Oauth2Permissions | FT ID, UserConsentDisplayName

$Pbi = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
$Pbi.ResourceAppId = $svcprincipalPbi.AppId

$Aad = New-Object -TypeName "Microsoft.Open.AzureAD.Model.RequiredResourceAccess"
$Aad.ResourceAppId = $svcprincipalAAD.AppId

$delPermission1 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" 
-ArgumentList "a42657d6-7f20-40e3-b6f0-cee03008a62a","Scope" ## Access the directory as you

$delPermission4 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "47df08d3-85e6-4bd3-8c77-680fbe28162e","Scope" ## View all Groups
$delPermission3 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "a65a6bd9-0978-46d6-a261-36b3e6fdd32e","Scope" ## View users Groups
$delPermission2 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "ddd37690-e119-40c5-a821-3746ea6125c4","Scope" ## Read and write all dataflows
$delPermission5 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "4ae1bf56-f562-4747-b7bc-2fa0874ed46f","Scope" ## View all Reports
$delPermission6 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "f3076109-ca66-412a-be10-d4ee1be95d47","Scope" ## Create content
$delPermission7 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "322b68b2-0804-416e-86a5-d772c567b6e6","Scope" ## Read and Write all Datasets
$delPermission8 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "7f33e027-4039-419b-938e-2f8ca153e68e","Scope" ## View all Datasets
$delPermission9 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "2448370f-f988-42cd-909c-6528efd67c1a","Scope" ## View all Dashboards
$delPermission10 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess"`
 -ArgumentList "ecc85717-98b0-4465-af6d-1cbba6f9c961","Scope" ## Add data to any of your datasets in Power BI
$delPermission11 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "b271f05e-8329-4b97-baa4-91cf15b99cf1","Scope" ## Read and Write all Dashboards
$delPermission12 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "445002fb-a6f2-4dc1-a81e-4254a111cd29","Scope" ## Read and write all workspaces
$delPermission13 = New-Object -TypeName "Microsoft.Open.AzureAD.Model.ResourceAccess" `
-ArgumentList "b2f1b2fa-f35c-407c-979c-a858a808ba85","Scope" ## View all workspaces

$Aad.ResourceAccess = $delPermission1
$Pbi.ResourceAccess = $delPermission2, $delPermission3 , $delPermission4 
, $delPermission5 , $delPermission6 , $delPermission7 , $delPermission8 ,
 $delPermission9 , $delPermission10 , $delPermission11 , $delPermission12 , $delPermission13 

$ADApplication = Get-AzureADApplication -All $true | ? { $_.AppId -match "<Your App ID> " }
Set-AzureADApplication -ObjectId $ADApplication.ObjectId -RequiredResourceAccess $Pbi, $Aad


