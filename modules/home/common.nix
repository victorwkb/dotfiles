{
  config,
  lib,
  pkgs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  xdg.enable = true;

  home.file = {
    ".config/nushell/theme.nu".source =
      "${pkgs.nu_scripts}/share/nu_scripts/themes/nu_themes/catppuccin-macchiato.nu";
    ".claude".source = mkOutOfStoreSymlink "${config.home.homeDirectory}/obsidian/claude-code-wiki";
  };

  home.activation.ensureClaudeVault = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    mkdir -p "${config.home.homeDirectory}/obsidian/claude-code-wiki"
  '';

  xdg.configFile.nvim.source = mkOutOfStoreSymlink "${config.home.homeDirectory}/dotfiles/nvim";

  home.sessionPath = [
    "/run/current-system/sw/bin"
    "$HOME/.nix-profile/bin"
  ];

  programs = {
    home-manager.enable = true;
    git = import ./git.nix { inherit pkgs; };
    starship = import ./starship.nix { inherit pkgs; };
    tmux = import ./tmux.nix { inherit pkgs; };
    zoxide = import ./zoxide.nix { inherit pkgs; };
    zsh = import ./zsh.nix { inherit pkgs; };
    nushell = import ./nushell.nix { inherit pkgs; };
    carapace = import ./carapace.nix { inherit pkgs; };
    yazi = import ./yazi.nix { inherit pkgs; };
  };
}
