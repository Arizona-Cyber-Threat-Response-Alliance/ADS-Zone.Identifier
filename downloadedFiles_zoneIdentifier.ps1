# ADS Zone Identifier for Downloaded Files
# Date: 06-07-2021
# Author to blame when it breaks: Christian Taillon
# Description: This script attempts to identify downloaded files as a well as the url from which the file was downloaded in System32 directory if information is available.

# set varriables
New-Variable -Name "sys32_path" -Value  "C:\Windows\System32\*"
New-Variable -Name "iso_downloads_path" -Value  "C:\Users\*\Downloads\*.iso"
New-Variable -Name "img_downloads_path" -Value  "C:\Users\*\Downloads\*.img"

# get files by path
$sys32_files = Get-Item $sys32_path  -Stream "Zone.Identifier" -ErrorAction SilentlyContinue
$iso_downloads_files = Get-Item $iso_downloads_path  -Stream "Zone.Identifier" -ErrorAction SilentlyContinue
$img_downloads_files = Get-Item $img_downloads_path  -Stream "Zone.Identifier" -ErrorAction SilentlyContinue

# loop through each file to get the stream content
$sys32_files | ForEach {
  Write-Host  "System32-Downloaded-Object"
  Write-Host "FileName:" $_.FileName
  Write-Host "Path:" $_.PSParentPath

  # because get-content does not return an object, can't easily format
  # if someone wants to parse the reutn, to format output as .json or .csv, that would be bomb!
  #$content = get-content $_.PSPath -Stream Zone.Identifier -ErrorAction SilentlyContinue
  #$content | foreach {
    #Write-Host "ZoneId", $_.ZoneId
    #Write-Host "HostUrl", $_.HostUrl

  Get-Content $_.PSPath -Stream Zone.Identifier -ErrorAction SilentlyContinue
  Write-Host  "`n"
}

$iso_downloads_files |  Where-Object {$_.FileName -notlike "*windows*" -and $_.FileName -notlike "*debian*" -and $_.FileName -notlike "*ubuntu*" -and $_.FileName -notlike "*centos*" -and $_.FileName -notlike "*raspios*" } | ForEach {
  Write-Host "Img-Downloaded-Object"
  Write-Host "FileName:" $_.FileName
  Write-Host "Path:" $_.PSParentPath
  Get-Content $_.PSPath -Stream Zone.Identifier -ErrorAction SilentlyContinue
  Write-Host  "`n"
}

$img_downloads_files |  Where-Object {$_.FileName -notlike "*windows*" -and $_.FileName -notlike "*debian*" -and $_.FileName -notlike "*ubuntu*" -and $_.FileName -notlike "*centos*" -and $_.FileName -notlike "*raspios*" } | ForEach {
  Write-Host "Img-Downloaded-Object"
  Write-Host "FileName:" $_.FileName
  Write-Host "Path:" $_.PSParentPath
  Get-Content $_.PSPath -Stream Zone.Identifier -ErrorAction SilentlyContinue
  Write-Host  "`n"
}
