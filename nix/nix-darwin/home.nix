{
  config,
  pkgs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  home.username = "victorwkb";
  home.homeDirectory = "/Users/victorwkb";
  home.stateVersion = "24.05"; # Please read the comment before changing.

  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/victorwkb/dotfiles/nvim";

  home.file = {
    ".zshrc".source = ../../.config/zsh/.zshrc;
    ".config/aerospace/aerospace.toml".source = ../../.config/aerospace/aerospace.toml;
    ".config/nushell/theme.nu".source = "${pkgs.nu_scripts}/share/nu_scripts/themes/nu_themes/catppuccin-macchiato.nu";
    ".config/ghostty/config".source = ../../.config/ghostty/config;
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs = {
    home-manager.enable = true;
    git = import ../home/git.nix { inherit pkgs; };
    # kitty = import ../home/kitty.nix { inherit pkgs; };
    starship = import ../home/starship.nix { inherit pkgs; };
    tmux = import ../home/tmux.nix { inherit pkgs; };
    zoxide = import ../home/zoxide.nix { inherit pkgs; };
    zsh = import ../home/zsh.nix { inherit pkgs; };
    nushell = import ../home/nushell.nix { inherit pkgs; };
    carapace = import ../home/carapace.nix { inherit pkgs; };
    yazi = import ../home/yazi.nix { inherit pkgs; };
  };
}
