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

# --- SYSTEM TWEAK FUNCTIONS ---
function ApplySystemTweaks {
    powercfg -duplicatescheme e9a42b02-d5df-448d-aa00-03f14749eb61
   
    Get-AppxPackage -Name "MicrosoftWindows.Client.WebExperience" | Remove-AppxPackage


# Disable automatic time synchronization
        Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NoSync"
        Stop-Service w32time
        Set-Service w32time -StartupType Disabled

    Set-Culture -CultureInfo "en-US"
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "LocaleName" -Value "en-US"
    Set-ItemProperty -Path "HKCU:\Control Panel\International" -Name "GeoName" -Value "US"
    Set-TimeZone -Id "W. Europe Standard Time"
    Set-WinHomeLocation -GeoId 94
    # Enable automatic time synchronization
    Set-Service w32time -StartupType Automatic
    Start-Service w32time
    Set-ItemProperty -Path "HKLM:\SYSTEM\CurrentControlSet\Services\W32Time\Parameters" -Name "Type" -Value "NTP"

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "EnableTransparency" -Value 0
    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop\WindowMetrics" -Name "MinAnimate" -Value "0" -Type String

    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewAlphaSelect" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ListviewShadow" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarAnimations" -Value 0

    Set-ItemProperty -Path "HKCU:\Control Panel\Desktop" -Name "UserPreferencesMask" -Value ([byte[]](0x90,0x12,0x03,0x80,0x10,0x00,0x00,0x00))
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Search\' -Name 'SearchboxTaskbarMode' -Value 0
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name "TaskbarAl" -Value 0
    Set-ItemProperty -Path "HKCU:\SOFTWARE\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "MMTaskbarEnabled" -Value 0 -Type DWord
   
    Set-ItemProperty -Path 'HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced' -Name "ShowTaskViewButton" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarBadges" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "ShowTaskbarOnAllDisplays" -Value 0 -Force
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "AppsUseLightTheme" -Value 0
    Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Themes\Personalize" -Name "SystemUsesLightTheme" -Value 0
}

function RestartExplorer {
    Stop-Process -Name explorer -Force
}
Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0
ApplySystemTweaks
RestartExplorer

# Define a list of programs to install via winget
$programs = @(
        "Git.Git"                       
        "SteffenBruentjen.EurKEY"
        "9PM5VM1S3VMQ"                       
        "Google.GoogleDrive"
        "OBSProject.OBSStudio"
        "AppWork.JDownloader"
        "LocalSend.LocalSend"
        "qBittorrent.qBittorrent"
        "Unity.Unity.2023"
        "Python.Python.3.12"
        "GitHub.GitHubDesktop"
        "nepnep.neofetch-win"
        "MartinFinnerup.YouTubeMusicforDesktop"
        "XP8K2L36VP0QMB"
        "OpenJS.NodeJS"
        "Notion.Notion"
        "GitHub.cli"
        "CondaForge.Miniforge3"
        "Node.js.LTS"
        "Discord.Discord"
        "Brave.Brave"
        "Insomnia.Insomnia"
"anki.anki"
"RARLab.WinRAR"                       
"Python.Python.3"                       
"Google.Chrome"
"Valve.Steam"
"Microsoft.WindowsTerminal"  
"Microsoft.PowerShell"          
"7zip.7zip"                         
"JetBrains.Toolbox"                         
"Microsoft.VisualStudio.2022.Community"                         
"OpenJS.Node.js"                  
"Docker.DockerDesktop"
"Microsoft.VisualStudioCode"
"Neovim.Neovim"
"OpenVPNTechnologies.OpenVPN"
"Element.Element"
"JanDeDobbeleer.OhMyPosh"
"wez.wezterm"
"glzr-io.glazewm"
"Microsoft.PowerToys"
"Notion.NotionCalendar"
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
        "9NFTCH6J7FHV",
        "9NBLGGH4R32N",
        "9NRX63209R7B",
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
            Write-Host "Uninstalling ${program}..." -ForegroundColor Green
                try {
                    winget uninstall --id "${program}" --silent
                        Write-Host "${program} removed successfully." -ForegroundColor Yellow
                } catch {
                    Write-Host "Failed to uninstall ${program}: $($_.Exception.Message)" -ForegroundColor Red
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

# Install Kali Linux and Ubuntu using WSL
Write-Host "Installing Kali Linux (this may take a few minutes)..." -ForegroundColor Green
try {
    wsl --install -d kali-linux
    Write-Host "Kali Linux installed successfully." -ForegroundColor Cyan
} catch {
    Write-Host "Failed to install Kali Linux: $($_.Exception.Message)" -ForegroundColor Red
}

Write-Host "Installing Ubuntu (this may take a few minutes)..." -ForegroundColor Green
try {
    wsl --install -d Ubuntu
    Write-Host "Ubuntu installed successfully." -ForegroundColor Cyan
} catch {
    Write-Host "Failed to install Ubuntu: $($_.Exception.Message)" -ForegroundColor Red
}

RestartExplorer

Write-Host "Press Enter to exit"
Read-Host

#Set-ItemProperty -Path "HKCU:\Software\Microsoft\Windows\CurrentVersion\Explorer\Advanced" -Name "TaskbarDa" -Value 0
