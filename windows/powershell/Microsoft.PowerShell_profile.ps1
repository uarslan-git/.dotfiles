oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\clean-detailed.omp.json" | Invoke-Expression

#Remove prior aliases

# Aliases
Set-Alias nf neofetch
Function dfs { Set-Location "$HOME\.dotfiles" }
Function ga { git add $args }
Function gp { git push }