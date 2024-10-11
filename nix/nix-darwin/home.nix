{
  config,
  pkgs,
  ...
}:

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
    ".tmux.conf".source = ~/dotfiles/tmux/.tmux.conf;
    ".config/aerospace".source = ~/dotfiles/aerospace;
    ".config/personal".source = ~/dotfiles/personal;
    ".config/starship.toml".source = ~/dotfiles/starship/starship.toml;
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs = {
    git = import ../home/git.nix { inherit pkgs; };
    kitty = import ../home/kitty.nix { inherit pkgs; };
    starship = import ../home/starship.nix { inherit pkgs; };
    # tmux = import ../home/tmux.nix { inherit pkgs; };
    zoxide = import ../home/zoxide.nix { inherit pkgs; };
    zsh = import ../home/zsh.nix { inherit pkgs; };
  };
}
