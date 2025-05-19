# PowerShell script to uninstall gito on Windows
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

Write-ColorOutput "Uninstalling gito..." "Green"

# Default installation directory
$userProfilePath = if ([string]::IsNullOrEmpty($env:USERPROFILE)) { $env:HOME } else { $env:USERPROFILE }

if ([string]::IsNullOrEmpty($userProfilePath)) {
    Write-ColorOutput "Error: Could not determine user profile directory (USERPROFILE and HOME are not set)." "Red"
    Write-ColorOutput "Please specify the installation path manually or ensure USERPROFILE or HOME is set." "Yellow"
    exit 1
}

$installBaseDir = "gito"
$installBinDir = "bin"
$installDir = Join-Path $userProfilePath $installBaseDir $installBinDir
$binaryPath = Join-Path $installDir "gito.exe"

if (Test-Path $binaryPath) {
    Write-ColorOutput "Found gito installation at: $binaryPath" "Green"
    
    try {
        # Remove the binary
        Remove-Item -Path $binaryPath -Force
        Write-ColorOutput "Removed gito executable" "Green"
        
        # Attempt to remove the directory if it's empty
        if (-not (Get-ChildItem -Path $installDir)) {
            Remove-Item -Path $installDir -Force
            
            # Try to remove parent directory if empty
            $parentDir = Join-Path $userProfilePath $installBaseDir
            if (-not (Get-ChildItem -Path $parentDir)) {
                Remove-Item -Path $parentDir -Force
            }
            
            Write-ColorOutput "Removed installation directory" "Green"
        }
        
        Write-ColorOutput "gito has been uninstalled successfully!" "Green"
        Write-ColorOutput "Note: You may want to remove $installDir from your PATH manually if you added it." "Yellow"
    }
    catch {
        Write-ColorOutput "Error uninstalling gito: $_" "Red"
        exit 1
    }
}
else {
    Write-ColorOutput "Could not find gito installation at expected location: $binaryPath" "Yellow"
    Write-ColorOutput "If gito is installed elsewhere, please delete it manually." "Yellow"
}

Write-ColorOutput "Uninstallation complete!" "Green" 