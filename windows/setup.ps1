if (!
    # current role
    (New-Object Security.Principal.WindowsPrincipal(
        [Security.Principal.WindowsIdentity]::GetCurrent()
    # is admin?
    )).IsInRole(
        [Security.Principal.WindowsBuiltInRole]::Administrator
    )
) {
    # elevate script and exit current non-elevated runtime
    Start-Process `
        -FilePath 'powershell' `
        -ArgumentList (
            # flatten to single array
            '-File', $MyInvocation.MyCommand.Source, $args `
            | %{ $_ }
        ) `
        -Verb RunAs
    exit
}

# Define a list of programs to install via winget
$programs = @(
    "Git.Git"                    
    "9PM5VM1S3VMQ"                    
    "Node.js.LTS"                
    "Python.Python.3"            
    "Microsoft.WindowsTerminal"  
    "JetBrains.IntelliJIDEA.Ultimate" 
    "Microsoft.PowerShell"       
    "7zip.7zip"                  
    "JetBrains.Toolbox"                  
    "Microsoft.VisualStudio.2022.Community"                  
    "OpenJS.Node.js"             
    "Docker.DockerDesktop"
    "Microsoft.VisualStudioCode"
    "Neovim.Neovim"
    "JanDeDobbeleer.OhMyPosh"
    "wez.wezterm"
    "glzr-io.glazewm"
    "Microsoft.PowerToys"
    "Notion.NotionCalendar"
    "Notion.Notion"
)

# Loop through the list and install each program via winget
foreach ($program in $programs) {
    Write-Host "Installing ${program}..." -ForegroundColor Green
    try {
        winget install --id "${program}" --silent --accept-source-agreements --accept-package-agreements
        Write-Host "${program} installed successfully." -ForegroundColor Cyan
    } catch {
        Write-Host "Failed to install ${program}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Define a list of PowerShell modules to install
$modules = @(
    "Terminal-Icons",
    "Posh-Git",
    "PSReadline",
    "Microsoft.PowerShell.SecretManagement",
    "Microsoft.PowerShell.SecretStore"
)

# Install each module from PSGallery
foreach ($module in $modules) {
    Write-Host "Installing PowerShell module ${module}..." -ForegroundColor Green
    try {
        Install-Module -Name $module -Repository PSGallery -Force -AllowClobber -Scope CurrentUser
        Write-Host "${module} installed successfully." -ForegroundColor Cyan
    } catch {
        Write-Host "Failed to install ${module}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Remove Windows bloatware using winget
$bloatware = @(
    "Microsoft.OneDrive",
    "Microsoft.XboxApp",
    "Microsoft.XboxGameOverlay",
    "Microsoft.XboxGamingOverlay",
    "Microsoft.YourPhone",
    "Microsoft.ZuneMusic",
    "Microsoft.ZuneVideo",
    "Microsoft.BingWeather",
    "Microsoft.WindowsAlarms",
    "Microsoft.WindowsCamera",
    "Microsoft.WindowsMaps",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.WindowsSoundRecorder",
    "Microsoft.3DViewer",
    "Microsoft.MixedReality.Portal",
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.People",
    "Microsoft.SkypeApp"
)

foreach ($program in $bloatware) {
    Write-Host "Installing ${program}..." -ForegroundColor Green
    try {
        winget remove --id "${program}" --silent --accept-source-agreements --accept-package-agreements
        Write-Host "${program} installed successfully." -ForegroundColor Cyan
    } catch {
        Write-Host "Failed to install ${program}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Symlink specified files to their target locations
$filesToLink = @(
    @{ Source = "$HOME/.dotfiles/windows/glaze/config.yaml"; Target = "$HOME/.glzr/glazewm/config.yaml" }
    @{ Source = "$HOME/.dotfiles/windows/powershell/Microsoft.PowerShell_profile.ps1"; Target = "$HOME/Documents/WindowsPowerShell/Microsoft.PowerShell_profile.ps1" }
    @{ Source = "$HOME/.dotfiles/windows/.wezterm.lua"; Target = "$HOME/.wezterm.lua" }
    @{ Source = "$HOME/.dotfiles/windows/PowerToys/settings.ptb"; Target = "$HOME/PowerToys/Backup/settings.ptb" }
)

foreach ($file in $filesToLink) {
    $sourcePath = $file["Source"]
    $targetPath = $file["Target"]

    Write-Host "Creating symlink for $sourcePath..." -ForegroundColor Green
    try {
        # Ensure the target directory exists
        $targetDirectory = [System.IO.Path]::GetDirectoryName($targetPath)
        if (!(Test-Path -Path $targetDirectory)) {
            Write-Host "Creating directory $targetDirectory..." -ForegroundColor Yellow
            New-Item -ItemType Directory -Path $targetDirectory -Force | Out-Null
        }

        # If the target already exists, remove it
        if (Test-Path -Path $targetPath) {
            Write-Host "Deleting existing file or symlink at $targetPath..." -ForegroundColor Yellow
            Remove-Item -Path $targetPath -Force
        }

        # Create the symlink
        New-Item -ItemType SymbolicLink -Path $targetPath -Target $sourcePath
        Write-Host "Symlink created for $sourcePath." -ForegroundColor Cyan
    } catch {
        Write-Host "Failed to create symlink for ${sourcePath}: $($_.Exception.Message)" -ForegroundColor Red
    }
}

# Pause the script to view errors or output
Write-Host "Press Enter to exit"
Read-Host

