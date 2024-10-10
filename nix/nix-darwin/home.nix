# home.nix
# home-manager switch

{ config, pkgs, ... }:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  programs.home-manager.enable = true;

  home.username = "victorwkb";
  home.homeDirectory = "/Users/victorwkb";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/victorwkb/dotfiles/nvim";

  home.file = {
    ".zshrc".source = ~/dotfiles/zsh/.zshrc;
    ".zsh_profile".source = ~/dotfiles/zsh/.zsh_profile;
    ".gitconfig".source = ~/dotfiles/git/.gitconfig;
    ".tmux.conf".source = ~/dotfiles/tmux/.tmux.conf;
    ".config/aerospace".source = ~/dotfiles/aerospace;
    ".config/kitty".source = ~/dotfiles/kitty;
    ".config/personal".source = ~/dotfiles/personal;
    ".config/starship.toml".source = ~/dotfiles/starship/starship.toml;
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs.zsh = {
    enable = true;
    initExtra = ''
      # Add any additional configurations here
      export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
      if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
        . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
      fi
    '';
  };
}
