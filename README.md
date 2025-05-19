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

gito is a command-line tool to manage multiple Git user profiles.

```bash
gito <COMMAND>
```

**Available commands:**

*   `gito add`
    *   Prompts you to add a new user profile, asking for a name and email.
*   `gito remove`
    *   Lists the existing user profiles and prompts you to select one to remove.
*   `gito list`
    *   Displays all saved user profiles with their associated names and emails.
*   `gito select`
    *   Lists the existing user profiles and prompts you to select one. The selected user's git `user.name` and `user.email` will be set globally.

If no command is provided, gito will display its name, version, author, and a brief description, followed by the list of available commands.

## Running Locally

To run gito locally for development or testing, you'll need to have Rust and Cargo installed. You can find installation instructions at [rust-lang.org](https://www.rust-lang.org/tools/install).

Once Rust is set up, follow these steps:

1.  **Clone the repository:**
    ```bash
    git clone https://github.com/pedro3g/gito.git
    cd gito
    ```

2.  **Run the application:**
    ```bash
    cargo run
    ```
    This command will compile and run the `gito` executable. You can then use it as described in the [Usage](#usage) section. For example:
    ```bash
    cargo run -- add
    cargo run -- list
    ```
    The `--` is used to separate arguments for `cargo run` from arguments for your program.

3.  **Build for release (optional):**
    If you want to build an optimized release version, use:
    ```bash
    cargo build --release
    ```
    The executable will be located at `target/release/gito` (or `target\release\gito.exe` on Windows).

## License

This project is licensed under the MIT License - see the LICENSE file for details.
