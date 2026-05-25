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
  home.file.".config/ghostty/config".source = ../../.config/ghostty/config;

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy | tmux load-buffer - && tmux paste-buffer"
  '';

  programs.git.settings.user = {
    name = "victorwkb";
    email = "victorwkb@gmail.com";
  };
}
