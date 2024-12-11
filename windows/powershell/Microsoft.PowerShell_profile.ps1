oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\clean-detailed.omp.json" | Invoke-Expression

#Remove prior aliases

# Aliases
Set-Alias nf neofetch
Set-Alias n nvim
Set-Alias vim nvim
Function e { explorer . }
Function dfs { Set-Location "$HOME\.dotfiles" }
Function gita { git add $args }
Function gitc { git commit -m $args}
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
        [int]$hours
    )
    
    $shutdownTime = (Get-Date).AddHours($hours)
    $shutdownTimeFormatted = $shutdownTime.ToString("HH:mm:ss")
    
    Write-Host "Shutting down in $hours hours at $shutdownTimeFormatted..."
    Shutdown.exe /s /f /t ($hours * 3600)
}

Function sdc {
    Write-Host "Cancelling scheduled shutdown..."
    Shutdown.exe /a
}

