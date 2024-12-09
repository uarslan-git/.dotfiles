#!/bin/bash

# Ensure the script is run with administrator privileges
echo "Starting development environment setup..."

# Function to check if a command exists
function command_exists {
    command -v "$1" &> /dev/null
}

# Install WSL and set up Ubuntu
if ! command_exists wsl; then
    echo "Installing WSL..."
    wsl --install -d Ubuntu
    echo "WSL installation complete. Restart required to continue setup."
    exit 0
else
    echo "WSL is already installed."
fi

# Update WSL
wsl.exe --update

# Install other development tools
dev_tools=(
    "Git.Git"                    # Git
    "Node.js.LTS"                # Node.js LTS
    "Python.Python.3"            # Python 3
    "Microsoft.WindowsTerminal"  # Windows Terminal
    "JetBrains.IntelliJIDEA.Ultimate" # IntelliJ IDEA (Optional)
    "Microsoft.PowerShell"       # PowerShell
    "7zip.7zip"                  # 7-Zip
    "OpenJS.Node.js"             # Node.js
    "Microsoft.VisualStudio.Enterprise" # Visual Studio (Optional)
    "Docker.DockerDesktop"
    "Microsoft.VisualStudioCode"
    "Neovim.Neovim"
)

for tool in "${dev_tools[@]}"; do
    echo "Installing $tool..."
    winget install --id=$tool -e
done

# Install additional tools inside WSL
echo "Configuring development tools inside WSL..."
wsl bash -c "
sudo apt update && sudo apt upgrade -y
sudo apt install -y build-essential curl wget zsh fzf tmux ripgrep
"

# Install PowerShell Core
if ! command_exists pwsh; then
    echo "Installing PowerShell Core..."
    winget install --id=Microsoft.PowerShell -e
else
    echo "PowerShell Core is already installed."
fi

# Completion message
echo "Development environment setup is complete! Restart your system to ensure all changes take effect."

