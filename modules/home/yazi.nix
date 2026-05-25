{ pkgs, ... }:
{
  enable = true;
  enableNushellIntegration = true;
  enableZshIntegration = true;

  settings = {
    manager = {
      show_hidden = true;
      sort_by = "mtime";
      sort_dir_first = true;
    };
  };
  shellWrapperName = "y";
}
