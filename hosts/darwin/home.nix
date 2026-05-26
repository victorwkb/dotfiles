{ pkgs, ... }:
{
  imports = [ ../../modules/home/common.nix ];

  programs.vscode = import ../../modules/home/vscode.nix { inherit pkgs; };

  home.username = "victorwkb";
  home.homeDirectory = "/Users/victorwkb";
  home.stateVersion = "26.05";

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
