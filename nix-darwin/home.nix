# home.nix
# home-manager switch

{ config, pkgs, ... }:

{
  home.username = "victorwkb";
  home.homeDirectory = "/Users/victorwkb";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  home.packages = [
  ];

  # Home Manager is pretty good at managing dotfiles. The primary way to manage
  # plain files is through 'home.file'.
  home.file = {
    ".zshrc".source = ~/dotfiles/zsh/.zshrc;
    ".zsh_profile".source = ~/dotfiles/zsh/.zsh_profile;
    ".gitconfig".source = ~/dotfiles/git/.gitconfig;
    ".tmux.conf".source = ~/dotfiles/tmux/.tmux.conf;
    ".config/aerospace".source = ~/dotfiles/aerospace;
    ".config/alacritty".source = ~/dotfiles/alacritty;
    ".config/kitty".source = ~/dotfiles/kitty;
    ".config/nix".source = ~/dotfiles/nix;
    ".config/nix-darwin".source = ~/dotfiles/nix-darwin;
    ".config/nvim".source = ~/dotfiles/nvim;
    ".config/personal".source = ~/dotfiles/personal;
    ".config/starship.toml".source = ~/dotfiles/starship/starship.toml;
  };

  home.sessionVariables = {
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs.home-manager.enable = true;
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
