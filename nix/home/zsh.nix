{ pkgs, ... }:
{
  enable = true;

  shellAliases = {
    v = "nvim";
    python = "python3";
    pip = "pip3";
    wsl = "wsl.exe";

    dot = "cd ~/dotfiles";

    cat = "bat";
    head = "coreutils head";

    ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    ll = "eza -l";
    la = "eza -la";
    lla = "eza -Tla";
    tree = "eza -T";
    ltree = "eza -Tl";

    drs = "darwin-rebuild switch --flake ~/dotfiles/nix/nix-darwin";
  };

  initContent = ''
    export BAT_THEME="Catppuccin Macchiato"

    export NVM_DIR="$HOME/.config/nvm"
    [ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"
    [ -s "$NVM_DIR/bash_completion" ] && . "$NVM_DIR/bash_completion"

    export VIM="nvim"
    export XDG_CONFIG_HOME="$HOME/.config"
    export PATH="$HOME/bin:$HOME/.local/bin:$PATH"
    export GIT_EDITOR="$VIM"
    export DOTFILES="$HOME/dotfiles"
    export NIX_CONF_DIR="$HOME/.config/nix"
    export STOW_FOLDERS="aerospace,alacritty,bin,kitty,nvim,starship,tmux,zsh"

    addToPath() {
      if [[ "$PATH" != *"$1"* ]]; then
        export PATH="$PATH:$1"
      fi
    }

    addToPathFront() {
      if [[ "$PATH" != *"$1"* ]]; then
        export PATH="$1:$PATH"
      fi
    }

    addToPathFront "$HOME/dotfiles/.config/bin/.local/scripts"

    # Starship and zoxide init
    eval "$(starship init zsh)"
    eval "$(zoxide init zsh)"
    source <(fzf --zsh)
  '';
}
