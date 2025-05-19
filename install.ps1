# PowerShell script to install gito on Windows
# Author: Pedro Henrique

# Function to output colored text
function Write-ColorOutput {
    param(
        [Parameter(Mandatory=$true)]
        [string]$Message,
        [Parameter(Mandatory=$false)]
        [string]$Color = "White"
    )
    
    Write-Host $Message -ForegroundColor $Color
}

Write-ColorOutput "Installing gito..." "Green"

# Detect architecture
$arch = if ([Environment]::Is64BitOperatingSystem) {
    if ([System.Environment]::GetEnvironmentVariable("PROCESSOR_ARCHITECTURE") -eq "ARM64") {
        "arm64"
    } else {
        "amd64"
    }
} else {
    "386"
}

Write-ColorOutput "Detected platform: windows-$arch" "Green"

# Create installation directory
$userProfilePath = if ([string]::IsNullOrEmpty($env:USERPROFILE)) { $env:HOME } else { $env:USERPROFILE }

if ([string]::IsNullOrEmpty($userProfilePath)) {
    Write-ColorOutput "Error: Could not determine user profile directory (USERPROFILE and HOME are not set)." "Red"
    exit 1
}

$installBaseDir = "gito"
$installBinDir = "bin"
$installDir = Join-Path $userProfilePath $installBaseDir $installBinDir

# Create the directory if it doesn't exist
if (-not (Test-Path $installDir)) {
    Write-ColorOutput "Creating installation directory at $installDir..." "Green"
    New-Item -ItemType Directory -Path $installDir -Force | Out-Null
}

# Get latest release information
Write-ColorOutput "Fetching latest release information..." "White"
$releaseUrl = "https://api.github.com/repos/pedro3g/gito/releases/latest"

try {
    $releaseInfo = Invoke-RestMethod -Uri $releaseUrl -ErrorAction Stop
} catch {
    Write-ColorOutput "Error fetching release information: $_" "Red"
    exit 1
}

# Define the asset pattern
$assetPattern = "gito-windows-$arch.exe"
Write-ColorOutput "Looking for asset: $assetPattern" "Green"

# Find the matching asset
$asset = $releaseInfo.assets | Where-Object { $_.name -like $assetPattern }

if (-not $asset) {
    Write-ColorOutput "Error: Could not find a release for your platform (windows-$arch)" "Red"
    Write-ColorOutput "Available assets:" "Yellow"
    $releaseInfo.assets | ForEach-Object { Write-Host "  " $_.name }
    exit 1
}

$downloadUrl = $asset.browser_download_url
$version = $releaseInfo.tag_name

Write-ColorOutput "Latest version: $version" "Green"
Write-ColorOutput "Downloading from: $downloadUrl" "Green"

# Download the binary
$binaryPath = Join-Path $installDir "gito.exe"
Write-ColorOutput "Downloading binary..." "White"

try {
    Invoke-WebRequest -Uri $downloadUrl -OutFile $binaryPath -ErrorAction Stop
} catch {
    Write-ColorOutput "Error downloading binary: $_" "Red"
    exit 1
}

Write-ColorOutput "gito has been installed to: $binaryPath" "Green"

# Add to PATH instructions
Write-ColorOutput "Important Next Steps:" "Yellow"
Write-ColorOutput "1. Add the directory $installDir to your PATH environment variable." "White"
Write-ColorOutput "   To add to PATH in PowerShell (temporarily for current session):" "White"
Write-ColorOutput "     `$env:Path += `";$installDir`"" "Cyan"
Write-ColorOutput "   To add to PATH permanently:" "White"
Write-ColorOutput "     - Search for 'Edit the system environment variables' in Windows search." "White"
Write-ColorOutput "     - Click 'Environment Variables...' button." "White"
Write-ColorOutput "     - Under 'User variables', select 'Path' and click 'Edit...'." "White"
Write-ColorOutput "     - Click 'New' and add the path (replace <YourUsername> if needed): $userProfilePath\$installBaseDir\$installBinDir" "Cyan"
Write-ColorOutput "     - Click OK on all dialogs." "White"
Write-ColorOutput "   You MUST restart your PowerShell window for the PATH change to take effect." "Yellow"
Write-ColorOutput "2. After updating PATH, you can run 'gito' from any directory." "White"

# Try to update PATH for current session
try {
    $env:Path += ";$installDir"
    Write-ColorOutput "Added installation directory to PATH for current session." "Green"
} catch {
    Write-ColorOutput "Could not update PATH for current session: $_" "Yellow"
}

Write-ColorOutput "Installation complete! Enjoy using gito!" "Green" 