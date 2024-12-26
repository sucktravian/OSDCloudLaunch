#================================================
#   [PreOS] Update Module
#================================================
if ((Get-MyComputerModel) -match 'Virtual') {
    Write-Host  -ForegroundColor Green "Setting Display Resolution to 1600x"
    Set-DisRes 1600
}

Write-Host -ForegroundColor Green "Updating OSD PowerShell Module"
Install-Module OSD -Force -SkipPublisherCheck

Write-Host  -ForegroundColor Green "Importing OSD PowerShell Module"
Import-Module OSD -Force 

Start-OSDCloudGUIDEV


# Recursive download function
function Invoke-GitHubContent {
    param (
        [string]$url,
        [string]$localPath
    )
    $response = Invoke-RestMethod -Uri $url -Headers @{ "User-Agent" = "PowerShell" }
    foreach ($item in $response) {
        if ($item.type -eq "file") {
            $fileURL = $item.download_url
            $filePath = Join-Path -Path $localPath -ChildPath $item.name
            Write-Host -ForegroundColor Yellow "Downloading file: $item.name"
            Invoke-WebRequest -Uri $fileURL -OutFile $filePath
            Write-Host -ForegroundColor Green "Downloaded: $item.name"
        } elseif ($item.type -eq "dir") {
            $dirPath = Join-Path -Path $localPath -ChildPath $item.name
            if (!(Test-Path -Path $dirPath)) {
                New-Item -ItemType Directory -Path $dirPath | Out-Null
                Write-Host -ForegroundColor Yellow "Created folder: $dirPath"
            }
            Invoke-GitHubContent -url $item.url -localPath $dirPath
        }
    }
}

# Base URLs
$baseURL = "https://raw.githubusercontent.com/sucktravian/OSDCloudLaunch/main"
$repoOwner = "sucktravian"
$repoName = "OSDCloudLaunch"
$branch = "main"
$apiBaseURL = "https://api.github.com/repos/$repoOwner/$repoName/contents"

# Local path to save the files
$localBasePath = "C:\OSDCloud\Scripts"

# Files to download directly
$files = @(
    "unattend.xml",
    "Checker.ps1",
    "main.ps1",
    "Prepare-Sysprep.ps1",
    "runner.cmd",
    "Task.json"
)

# Ensure the base folder exists
if (!(Test-Path -Path $localBasePath)) {
    New-Item -ItemType Directory -Path $localBasePath | Out-Null
    Write-Host -ForegroundColor Yellow "Created folder: $localBasePath"
}

# Download each file
foreach ($file in $files) {
    $fileURL = "$baseURL/$file"
    $localPath = Join-Path -Path $localBasePath -ChildPath $file
    try {
        Invoke-WebRequest -Uri $fileURL -OutFile $localPath
        Write-Host -ForegroundColor Green "Downloaded: $file"
    } catch {
        Write-Host -ForegroundColor Red "Failed to download: $file. Error: $_"
    }
}

Write-Host -ForegroundColor Cyan "Starting download process..."
$rootURL = "$apiBaseURL/SettingModule?ref=$branch"
Invoke-GitHubContent -url $rootURL -localPath "$localBasePath\SettingModule"
Write-Host -ForegroundColor Cyan "Download process completed!"

