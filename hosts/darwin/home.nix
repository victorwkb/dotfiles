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
  imports = [ ../../modules/home/common.nix ];

  home.username = "victorwkb";
  home.homeDirectory = "/Users/victorwkb";
  home.stateVersion = "26.05";

  xdg.configFile.nvim.source = mkOutOfStoreSymlink "/Users/victorwkb/dotfiles/nvim";

  home.file.".config/aerospace/aerospace.toml".source = ../../.config/aerospace/aerospace.toml;
  home.file.".config/ghostty/config".source = ../../.config/ghostty/config;

  # Claude Code global dir — symlinked to Obsidian vault for cross-device sync via Obsidian Sync.
  # To activate: rm -rf ~/.claude && darwin-rebuild switch (home-manager creates the symlink).
  home.file.".claude".source = mkOutOfStoreSymlink "/Users/victorwkb/obsidian/claude-code-wiki";

  # Ensure vault dir exists before the symlink is written — prevents dangling symlink on
  # fresh machines where Obsidian Sync hasn't pulled the vault yet.
  home.activation.ensureClaudeVault = lib.hm.dag.entryBefore [ "checkLinkTargets" ] ''
    mkdir -p "/Users/victorwkb/obsidian/claude-code-wiki"
  '';

  programs.tmux.extraConfig = ''
    bind -T copy-mode-vi y send-keys -X copy-pipe-and-cancel "pbcopy"
    bind -T copy-mode-vi Enter send-keys -X copy-pipe-and-cancel "pbcopy | tmux load-buffer - && tmux paste-buffer"
  '';

  programs.git.settings.user = {
    name = "victorwkb";
    email = "victorwkb@gmail.com";
  };
}
