{ pkgs, ... }:
{
  enable = true;

  shellAliases = {
    v = "nvim";
    python = "python3";
    pip = "pip3";

    dot = "cd ~/dotfiles";

    cat = "bat";
    head = "coreutils head";

    ls = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
    ll = "eza -l";
    la = "eza -la";
    lla = "eza -Tla";
    tree = "eza -T";
    ltree = "eza -Tl";

    drs = "sudo darwin-rebuild switch --flake ~/dotfiles#macos";
    drsm = "sudo darwin-rebuild switch --flake 'github:victorwkb/dotfiles/main#macos'";
    nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#nixos";
    nrsm = "sudo nixos-rebuild switch --flake 'github:victorwkb/dotfiles/main#nixos'";
  };

  initContent = ''
    export BAT_THEME="Catppuccin Macchiato"
    export VIM="nvim"
    export XDG_CONFIG_HOME="$HOME/.config"
    export GIT_EDITOR="$VIM"
    export DOTFILES="$HOME/dotfiles"

    # Starship and zoxide init
    eval "$(starship init zsh)"
    eval "$(zoxide init zsh)"
    source <(fzf --zsh)
  '';
}
