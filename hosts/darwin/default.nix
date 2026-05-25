{ pkgs, inputs, ... }:
{
  nixpkgs.config.allowUnfree = true;

  environment.systemPackages = [
    pkgs.awscli
    pkgs.google-cloud-sdk
    pkgs.bat
    pkgs.eza
    pkgs.fastfetch
    pkgs.nerdfetch
    pkgs.cbonsai
    pkgs.cmatrix
    pkgs.htop
    pkgs.pipes
    pkgs.fd
    pkgs.fzf
    pkgs.git
    pkgs.lazygit
    pkgs.neovim
    pkgs.nodejs_22
    pkgs.carapace
    pkgs.nushell
    pkgs.nu_scripts
    pkgs.ripgrep
    pkgs.vim
    pkgs.wget
    pkgs.nil
    pkgs.nixfmt
    pkgs.ghostty-bin
    pkgs.claude-code
  ];

  users.users.victorwkb = {
    name = "victorwkb";
    home = "/Users/victorwkb";
  };

  system.primaryUser = "victorwkb";

  homebrew = {
    enable = true;
    brews = [ "mas" ];
    casks = [
      "aerospace"
      "jordanbaird-ice"
      "font-sf-mono"
    ];
    masApps = { };
    taps = [ "nikitabobko/tap" ];
    onActivation.cleanup = "zap";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

  nix.settings.experimental-features = "nix-command flakes";
  programs.zsh.enable = true;
  system.configurationRevision = inputs.self.rev or inputs.self.dirtyRev or null;
  system.stateVersion = 5;

  system.defaults = {
    dock.autohide = true;
    dock.autohide-delay = 0.0;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    screencapture.location = "~/Pictures/screenshots";
    screensaver.askForPasswordDelay = 10;
    NSGlobalDomain.InitialKeyRepeat = 10;
    NSGlobalDomain.KeyRepeat = 3;
  };

  nixpkgs.hostPlatform = "aarch64-darwin";
  nixpkgs.overlays =
    (import ../../overlays/default.nix { inherit inputs; })
    ++ [ inputs.claude-code.overlays.default ];
}
