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
  imports = [
    ../../modules/home/common.nix
    ../../modules/home/ghostty.nix
  ];

  home.username = "vicwkb";
  home.homeDirectory = "/home/vicwkb";
  home.stateVersion = "25.05";

  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/home/vicwkb/dotfiles/nvim";

  home.sessionPath = [ "/run/wrappers/bin" ];

  programs.nushell.extraEnv = ''
    $env.PATH = ($env.PATH | prepend "/run/wrappers/bin")
  '';

  home.file.".claude".source = mkOutOfStoreSymlink "/home/vicwkb/obsidian/claude-code-wiki";
  home.activation.ensureClaudeVault = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    mkdir -p "/home/vicwkb/obsidian/claude-code-wiki"
  '';

  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.zsh.shellAliases.wsl = "wsl.exe";
  programs.zsh.initContent = ''
    export PATH="/run/wrappers/bin:$PATH"
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "clip.exe"
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "clip.exe"
  '';

  programs.git.settings.user = {
    name = "victorgoh-zen";
    email = "victor.goh@zenenergy.com.au";
  };
}
