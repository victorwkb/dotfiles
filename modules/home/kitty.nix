{ pkgs, ... }:
{
  enable = true;
  shellIntegration.enableZshIntegration = true;
  font = {
    package = pkgs.sf-mono-liga-bin;
    name = "Liga SFMono Nerd Font";
    size = 16;
  };
  settings = {
    background_opacity = "0.85";
    background_blur = 20;
    disable_ligatures = "always";
    hide_window_decorations = "titlebar-only";
    window_padding_width = 4;
  };
  themeFile = "Catppuccin-Macchiato";
  extraConfig = ''
    shell zsh --login -c "if command -v tmux >/dev/null 2>&1; then tmux attach || tmux; else zsh; fi"
  '';
}
