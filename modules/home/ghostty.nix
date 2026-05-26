{ ... }:
{
  programs.ghostty = {
    enable = true;
    settings = {
      theme = "Catppuccin Macchiato";
      background-opacity = 0.85;
      background-blur-radius = 20;
      font-size = 16;
      font-family = "SFMono Nerd Font Lig";
      font-thicken = true;
      mouse-hide-while-typing = true;
      window-decoration = true;
      window-padding-balance = true;
      window-padding-x = 10;
      window-padding-y = 10;
      window-padding-color = "background";
    };
  };
}
