# Powerlevel10k instant prompt preamble
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
plugins=(git zsh-syntax-highlighting zsh-autosuggestions)

source $ZSH/oh-my-zsh.sh

. "$HOME/.asdf/asdf.sh"
. "$HOME/.asdf/completions/asdf.bash"

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

    # Install ASDF
    if [[ ! -d "$HOME/.asdf" ]]; then
        git clone https://github.com/asdf-vm/asdf.git ~/.asdf --branch v0.13.1
        echo -e '\n# ASDF\n. "$HOME/.asdf/asdf.sh"\n. "$HOME/.asdf/completions/asdf.bash"' >> ~/.zshrc
        source ~/.zshrc
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
    local programs=(git curl docker neovim fzf nodejs python)
    for program in "${programs[@]}"; do
        if ! command -v "$program" &> /dev/null; then
            case $program in
                git | curl | docker)
                    sudo apt-get install -y "$program" ;;
                neovim)
                    sudo apt-get install -y neovim ;;
                fzf)
                    git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
                    ~/.fzf/install --all ;;
                nodejs | python)
                    asdf plugin add "$program" || true
                    asdf install "$program" latest
                    asdf global "$program" latest ;;
            esac
        fi
    done

    # Install Packer (for Neovim)
    local packer_dir="$HOME/.local/share/nvim/site/pack/packer/start/packer.nvim"
    if [[ ! -d "$packer_dir" ]]; then
        git clone --depth 1 https://github.com/wbthomason/packer.nvim "$packer_dir"
    fi

    echo "Development environment setup complete!" >&2
}

# Call the setup function only if the environment is not already set up
if [[ ! -d "$HOME/.oh-my-zsh" || ! -d "$HOME/.asdf" || ! -d "$HOME/.fzf" ]]; then
    setup_dev_env
fi

# Aliases
alias dfs="cd ~/.dotfiles"
alias backup="pushd ~/.dotfiles; ga *; gcd; gp; popd"
alias cal="cal -wm"
alias ga="git add"
alias gb="git branch -a"
alias gc="git commit -m"
alias gcd="git commit -m '$(date)'"
alias gco="git checkout"
alias gl="git log --graph --pretty=oneline --abbrev-commit"
alias gp="git push"
alias gs="git status"
alias ra="ranger"
alias vi="nvim"
alias vim="nvim"
alias zshrc="vim ~/.zshrc"
alias n="nvim"
alias t="tmux"

# Fix Powerlevel10k instant prompt warning
#typeset -g POWERLEVEL9K_INSTANT_PROMPT=quiet

