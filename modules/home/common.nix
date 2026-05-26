{ pkgs, ... }:
{
  xdg.enable = true;

  home.file = {
    ".config/nushell/theme.nu".source =
      "${pkgs.nu_scripts}/share/nu_scripts/themes/nu_themes/catppuccin-macchiato.nu";
  };

  home.sessionPath = [
    "/run/wrappers/bin"
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
    vscode = import ./vscode.nix { inherit pkgs; };
  };
}
