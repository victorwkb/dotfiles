# Path to your oh-my-zsh installation.
export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME=""

plugins=(git zsh-autosuggestions zsh-history-substring-search)

source $ZSH/oh-my-zsh.sh

eval "$(starship init zsh)"
eval "$(zoxide init zsh)"
source <(fzf --zsh)

export BAT_THEME="Catppuccin Macchiato"

export NVM_DIR="$HOME/.config/nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"  # This loads nvm
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"  # This loads nvm bash_completion

VIM="nvim"
export XDG_CONFIG_HOME=$HOME/.config

# source $PERSONAL/env
# PERSONAL=$XDG_CONFIG_HOME/personal
# for i in `find -L $PERSONAL`; do
#     source $i
# done

# include wsl system bins
# export PATH="/bin/nvim-linux64/bin:$PATH"
# export PATH="/bin/wslpath:$PATH"

# include private bins
export PATH="$HOME/bin:$PATH"
export PATH="$HOME/.local/bin:$PATH"

# set git editor
export GIT_EDITOR=$VIM

export DOTFILES=$HOME/dotfiles

# Nix
export NIX_CONF_DIR=$HOME/.config/nix


. "$HOME/.cargo/env"

# Aliases
alias v="$VIM"
alias python="python3"
alias pip="pip3"
alias wsl="wsl.exe"
alias dot="cd ~/dotfiles"

alias cat="bat"
alias head="coreutils head"

# eza commands
alias ls="eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions"
alias ll="eza -l"
alias la="eza -la"
alias lla="eza -Tla"
alias tree="eza -T"
alias ltree="eza -Tl"

# darwin-rebuild switch
alias drs="darwin-rebuild switch --flake ~/dotfiles/nix/nix-darwin"

export STOW_FOLDERS="aerospace,alacritty,bin,kitty,nvim,starship,tmux,zsh"

addToPath() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$PATH:$1
    fi
}

addToPathFront() {
    if [[ "$PATH" != *"$1"* ]]; then
        export PATH=$1:$PATH
    fi
}

addToPathFront $HOME/dotfiles/.config/bin/.local/scripts
