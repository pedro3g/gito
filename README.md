# gito

Git organization and repository management tool

## Installation

### Option 1: Using the installation script

You can install gito with a single command:

#### Linux/macOS
```bash
curl -sSL https://raw.githubusercontent.com/pedro3g/gito/main/install.sh | bash
```

#### Windows
```powershell
# PowerShell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/pedro3g/gito/main/install.sh -OutFile install.sh
bash install.sh
```

If you're using Git Bash or WSL on Windows, you can use the Linux/macOS command.

### Option 2: Manual installation

1. Download the appropriate binary for your platform from the [latest release](https://github.com/pedro3g/gito/releases/latest):
   - **Windows**: `gito-windows-amd64.exe`
   - **macOS Intel**: `gito-macos-amd64`
   - **macOS Apple Silicon**: `gito-macos-arm64`
   - **Linux**: `gito-linux-amd64`

2. For Linux/macOS:
   - Make the file executable: `chmod +x gito-*`
   - Move to a directory in your PATH: `sudo mv gito-* /usr/local/bin/gito`

3. For Windows:
   - Rename the file to `gito.exe`
   - Move it to a directory in your PATH (e.g., `C:\Windows` or create a new directory and add it to your PATH)

## Uninstallation

### Option 1: Using the uninstallation script

#### Linux/macOS
```bash
curl -sSL https://raw.githubusercontent.com/pedro3g/gito/main/uninstall.sh | bash
```

#### Windows
```powershell
# PowerShell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/pedro3g/gito/main/uninstall.sh -OutFile uninstall.sh
bash uninstall.sh
```

### Option 2: Manual uninstallation

1. For Linux/macOS:
   ```bash
   sudo rm -f /usr/local/bin/gito
   ```

2. For Windows:
   - Delete the `gito.exe` file from your PATH

## Usage

```
# Command examples go here
```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
