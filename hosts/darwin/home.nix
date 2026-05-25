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

  home.username = "victorwkb";
  home.homeDirectory = "/Users/victorwkb";
  home.stateVersion = "26.05";

  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/victorwkb/dotfiles/nvim";

  home.file.".config/aerospace/aerospace.toml".source = ../../.config/aerospace/aerospace.toml;

  programs.git.settings.user = {
    name = "victorwkb";
    email = "victorwkb@gmail.com";
  };
}
