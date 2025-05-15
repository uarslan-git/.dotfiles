# Powerlevel10k instant prompt preamble
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"
export NVM_DIR="$HOME/.nvm"
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/nvm.sh"  # This loads nvm
[ -s "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm" ] && \. "/home/linuxbrew/.linuxbrew/opt/nvm/etc/bash_completion.d/nvm"  # This loads nvm bash_completion

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# Function to set up the development environment
setup_dev() {
    echo "Setting up development environment..." >&2

    # Install Oh-My-Zsh
    if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
        sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
    fi

    # Install Powerlevel10k
    if [[ ! -d "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k" ]]; then
        git clone --depth=1 https://github.com/romkatv/powerlevel10k.git ${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/themes/powerlevel10k
        sed -i 's/^ZSH_THEME=.*/ZSH_THEME="powerlevel10k\/powerlevel10k"/' ~/.zshrc
    fi

    # Install zsh plugins
    local plugins_dir="${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins"
    mkdir -p "$plugins_dir"

    if [[ ! -d "$plugins_dir/zsh-syntax-highlighting" ]]; then
        git clone https://github.com/zsh-users/zsh-syntax-highlighting.git "$plugins_dir/zsh-syntax-highlighting"
    fi

    if [[ ! -d "$plugins_dir/zsh-autosuggestions" ]]; then
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$plugins_dir/zsh-autosuggestions"
    fi

    # Install programs in the list
    local programs=(git curl docker neovim fzf nodejs wslu gh npm python3-full)
    for program in "${programs[@]}"; do
        if ! command -v "$program" &> /dev/null; then
            sudo apt-get install -y "$program"
        fi
    done

    # Install Packer (for Neovim)
    local packer_dir="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    if [[ ! -d "$packer_dir" ]]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_dir"
    fi

    # Install brew and packages
    if ! command -v brew &> /dev/null; then
        /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
        echo 'eval "$($(brew --prefix)/bin/brew shellenv)"' >> ~/.zshrc
        echo 'eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"' >> ~/.zshrc
        eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
    fi

    local brew_packages=(bat fd ripgrep tmux htop nvm)
    for package in "${brew_packages[@]}"; do
        if ! brew list "$package" &> /dev/null; then
            brew install "$package"
        fi
    done

    echo "Development environment setup complete!" >&2
}

# Call the setup function only if the environment is not already set up
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    setup_dev
fi
bindkey -s ^f "tmux-sessionizer\n"

systemctl --user import-environment 2> /dev/null

alias backup="pushd ~/; dconf-save; ga -u; gcd; gp; popd"
alias cal="cal -wm"
alias chrome="google-chrome-stable"
alias dconf-load="pushd ~/.config; dconf load / < dconf-settings; popd"
alias dconf-reset="dconf reset -f /"
alias dconf-save="pushd ~/.config; dconf dump / > dconf-settings; popd"
alias edit="vim ~/config/PKGBUILD"
alias ga="git add"
alias gb="git branch -a"
alias gc="git commit -m"
alias gcd="git commit -m '$(date)'"
alias gco="git checkout"
alias gl="git log --graph --pretty=oneline --abbrev-commit"
alias gls="git ls-files"
alias glu="git ls-files --others --exclude-standard"
alias glsf="git ls-files | awk -F'/' '{print \$1}' | sort | uniq"
alias gluf="git ls-files --others --exclude-standard | awk -F'/' '{print \$1}' | sort | uniq"
alias gp="git push"
alias gs="git status"
alias ra="ranger"
alias ra="ranger"
alias rb="backup; reboot"
alias sd="backup; shutdown now"
alias sudo="sudo "
alias update="pushd ~/config; PACMAN='paru' PACMAN_AUTH='eval' makepkg -fsi; popd"
alias udr="pushd ~/config; PACMAN='paru' PACMAN_AUTH='eval' makepkg -fsi --noconfirm; systemctl daemon-reload && systemctl --user daemon-reload && systemctl preset-all; popd"
alias vi="nvim"
alias vim="nvim"
alias nc="--noconfirm"
alias zshrc="vim ~/.zshrc"
alias rs="systemctl --user restart i3-session.target"
alias xclip="xclip -sel c"
alias n="nvim"
alias t="tmux"
alias zsh="vim ~/.zshrc"
alias a="ani-cli"

# Fix Powerlevel10k instant prompt warning
typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

eval "$($(brew --prefix)/bin/brew shellenv)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
