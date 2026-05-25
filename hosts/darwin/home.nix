{
  config,
  pkgs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;

  catppuccin = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "catppuccin";
    version = "unstable-2023-01-06";
    src = pkgs.fetchFromGitHub {
      owner = "dreamsofcode-io";
      repo = "catppuccin-tmux";
      rev = "main";
      sha256 = "sha256-FJHM6LJkiAwxaLd5pnAoF3a7AE1ZqHWoCpUJE0ncCA8=";
    };
  };
in
{
  home.username = "victorwkb";
  home.homeDirectory = "/Users/victorwkb";
  home.stateVersion = "26.05";

  xdg.enable = true;
  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/victorwkb/dotfiles/nvim";

  home.file = {
    ".config/aerospace/aerospace.toml".source = ../../.config/aerospace/aerospace.toml;
    ".config/nushell/theme.nu".source =
      "${pkgs.nu_scripts}/share/nu_scripts/themes/nu_themes/catppuccin-macchiato.nu";
    ".config/ghostty/config".source = ../../.config/ghostty/config;
  };

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs = {
    home-manager.enable = true;
    git = import ../../modules/home/git.nix { inherit pkgs; };
    starship = import ../../modules/home/starship.nix { inherit pkgs; };
    tmux = import ../../modules/home/tmux.nix { inherit pkgs catppuccin; };
    zoxide = import ../../modules/home/zoxide.nix { inherit pkgs; };
    zsh = import ../../modules/home/zsh.nix { inherit pkgs; };
    nushell = import ../../modules/home/nushell.nix { inherit pkgs; };
    carapace = import ../../modules/home/carapace.nix { inherit pkgs; };
    yazi = import ../../modules/home/yazi.nix { inherit pkgs; };
    vscode = import ../../modules/home/vscode.nix { inherit pkgs; };
  };
}
