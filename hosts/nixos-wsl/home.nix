{
  config,
  pkgs,
  ...
}:

let
  inherit (config.lib.file) mkOutOfStoreSymlink;
in
{
  imports = [ ../../modules/home/common.nix ];

  home.username = "vicwkb";
  home.homeDirectory = "/home/vicwkb";
  home.stateVersion = "25.05";

  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/home/vicwkb/dotfiles/nvim";

  programs.ghostty.enable = true;
  programs.zsh.dotDir = config.home.homeDirectory;
}
