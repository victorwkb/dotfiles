{ pkgs, ... }:
{
  enable = true;

  extraConfig = ''
    $env.config = {
      edit_mode: vi
      completions:{
        case_sensitive: false
        quick: true
        partial: true
        algorithm: "fuzzy"
      }
    }
  '';

  extraEnv = ''
    $env.EDITOR = "nvim"
    $env.PATH = ($env.PATH | prepend "/run/wrappers/bin")
  '';

  shellAliases = {
    v = "nvim";
    python = "python3";
    pip = "pip3";
    dot = "cd ~/dotfiles";
    cat = "bat";
    head = "coreutils head";
    l = "eza --color=always --long --git --no-filesize --icons=always --no-time --no-user --no-permissions";
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
}
