# gito

A simple way to manage local git users

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
Invoke-WebRequest -Uri https://raw.githubusercontent.com/pedro3g/gito/main/install.ps1 -OutFile install.ps1
./install.ps1
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
   - Create a directory (e.g., `%USERPROFILE%\gito\bin`) and move the executable there
   - Add this directory to your PATH environment variable

## Uninstallation

### Option 1: Using the uninstallation script

#### Linux/macOS
```bash
curl -sSL https://raw.githubusercontent.com/pedro3g/gito/main/uninstall.sh | bash
```

#### Windows
```powershell
# PowerShell
Invoke-WebRequest -Uri https://raw.githubusercontent.com/pedro3g/gito/main/uninstall.ps1 -OutFile uninstall.ps1
./uninstall.ps1
```

### Option 2: Manual uninstallation

1. For Linux/macOS:
   ```bash
   sudo rm -f /usr/local/bin/gito
   ```

2. For Windows:
   - Delete the `gito.exe` file from your installation directory (default: `%USERPROFILE%\gito\bin`)
   - Remove this directory from your PATH if you added it

## Usage

| Command | Description                                      |
| ------- | ------------------------------------------------ |
| `gito add`    | Add a new user                                   |
| `gito remove` | Remove a user                                    |
| `gito list`   | List all users                                   |
| `gito select` | Select a user and set git config globally        |

## Running from source

To run gito directly from the source code without installing it, you'll need to have Rust installed on your system.

1. Clone the repository:
   ```bash
   git clone https://github.com/pedro3g/gito.git
   cd gito
   ```

2. Run the project using cargo:
   ```bash
   cargo run -- <command>
   ```
   Replace `<command>` with one of the available commands: `add`, `remove`, `list`, or `select`.

   For example:
   ```bash
   cargo run -- list
   ```

## License

This project is licensed under the MIT License - see the LICENSE file for details.
