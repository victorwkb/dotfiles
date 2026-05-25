{ pkgs, inputs, ... }:
{
  imports = [ ../../modules/system/common.nix ];

  environment.systemPackages = [
    pkgs.awscli
    pkgs.google-cloud-sdk
    pkgs.ghostty-bin
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
    onActivation.cleanup = "uninstall";
    onActivation.autoUpdate = true;
    onActivation.upgrade = true;
  };

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
  nixpkgs.overlays = import ../../overlays/default.nix { inherit inputs; };
}
