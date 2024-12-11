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
