#Import-Module -Name Terminal-Icons
#Import-Module -Name Posh-Git
#Import-Module -Name PSReadline
#oh-my-posh --init --shell pwsh --config $env:POSH_THEMES_PATH/jandedobbeleer.omp.json | Invoke-Expression

#Set-PSReadLineOption -PredictionSource History
#Set-PSReadLineOption -PredictionViewStyle ListView
#Set-PSReadLineOption -EditMode Windows
#Set-PSReadLineOption -BellStyle None  # Disable beep

#git -C $HOME\.dotfiles\ pull origin

# Aliases
Set-Alias nf neofetch
Set-Alias n nvim
Set-Alias vim nvim

Function admin { Start-Process powershell -Verb runAs }
Function edit { nvim $HOME/.dotfiles/windows/setup.ps1 }
Function u { & $HOME/.dotfiles/windows/setup.ps1 }
Function e { explorer . }
Function dfs { Set-Location "$HOME\.dotfiles" }
Function gita { git add $args }
Function gitc { git commit -m $args }
Function gitcm { 
    $timestamp = Get-Date -Format "yyyy-MM-dd HH:mm:ss"
    git commit -m $timestamp
}
Function gitp { git push }

Function backup {
    dfs
    gita . 
    gitcm
    gitp
}

Function sd {
    backup
    param(
        [int]$hours = 0  # Default value of 0 for immediate shutdown
    )
    
    if ($hours -eq 0) {
        Write-Host "Shutting down now..."
        Shutdown.exe /s /f /t 0
    }
    else {
        $shutdownTime = (Get-Date).AddHours($hours)
        $shutdownTimeFormatted = $shutdownTime.ToString("HH:mm:ss")
        
        Write-Host "Shutting down in $hours hours at $shutdownTimeFormatted..."
        Shutdown.exe /s /f /t ($hours * 3600)
    }
}

Function sdc {
    Write-Host "Cancelling scheduled shutdown..."
    Shutdown.exe /a
}

# Enable Tab Completion for Files & Directories
Set-PSReadLineKeyHandler -Chord Tab -Function Complete
Set-PSReadLineKeyHandler -Chord Shift+Tab -Function Complete  # For backward cycling

