oh-my-posh init pwsh --config "$env:POSH_THEMES_PATH\clean-detailed.omp.json" | Invoke-Expression

#Remove prior aliases

# Aliases
Set-Alias nf neofetch
Set-Alias n nvim
Set-Alias vim nvim
Function e { explorer . }
Function dfs { Set-Location "$HOME\.dotfiles" }
Function ga { git add $args }
Function gp { git push }