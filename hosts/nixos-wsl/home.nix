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

  home.file.".claude".source = mkOutOfStoreSymlink "/home/vicwkb/obsidian/claude-code-wiki";

  home.activation.ensureClaudeVault = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    mkdir -p "/home/vicwkb/obsidian/claude-code-wiki"
  '';

  home.sessionPath = [ "/run/wrappers/bin" ];

  programs.nushell.extraEnv = ''
    $env.PATH = ($env.PATH | prepend "/run/wrappers/bin")
  '';

  programs.zsh.dotDir = "${config.xdg.configHome}/zsh";
  programs.zsh.shellAliases.wsl = "wsl.exe";
  programs.zsh.initContent = ''
    export PATH="/run/wrappers/bin:$PATH"
    _wcode="/mnt/c/Users/$(cmd.exe /c 'echo %USERNAME%' 2>/dev/null | tr -d '\r\n')/AppData/Local/Programs/Microsoft VS Code/bin/code"
    [[ -x "$_wcode" ]] && alias code="$_wcode"
  '';

  programs.nushell.extraConfig = ''
    def --wrapped code [...args] {
      let p = $"/mnt/c/Users/(cmd.exe /c 'echo %USERNAME%' | str trim)/AppData/Local/Programs/Microsoft VS Code/bin/code"
      ^$p ...$args
    }
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
