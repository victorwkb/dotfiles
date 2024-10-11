{
  description = "My Darwin system flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nix-homebrew.url = "github:zhaofengli-wip/nix-homebrew";
    homebrew-core = {
      url = "github:homebrew/homebrew-core";
      flake = false;
    };
    homebrew-cask = {
      url = "github:homebrew/homebrew-cask";
      flake = false;
    };
    sf-mono-liga-src = {
      url = "github:shaunsingh/SFMono-Nerd-Font-Ligaturized";
      flake = false;
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      home-manager,
      sf-mono-liga-src,
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          # List packages installed in system profile. To search by name, run:
          # $ nix-env -qaP | grep wget
          environment.systemPackages = [
            pkgs.awscli
            pkgs.bat
            pkgs.eza
            pkgs.fastfetch
            pkgs.fd
            pkgs.fzf
            pkgs.git
            pkgs.kitty
            pkgs.lazygit
            pkgs.neovim
            pkgs.ripgrep
            pkgs.vim
            pkgs.tmux
            # Languages
            pkgs.nil
            pkgs.nixfmt-rfc-style
          ];

          users.users.victorwkb = {
            name = "victorwkb";
            home = "/Users/victorwkb";
          };

          homebrew = {
            enable = true;
            brews = [ ];
            casks = [
              "nikitabobko/tap/aerospace"
            ];
            taps = [
              "nikitabobko/tap"
            ];
            onActivation.cleanup = "zap";
            onActivation.autoUpdate = true;
            onActivation.upgrade = true;
          };

          services.nix-daemon.enable = true;

          # Necessary for using flakes on this system.
          nix.settings.experimental-features = "nix-command flakes";

          programs.zsh.enable = true; # default shell on catalina

          security.pam.enableSudoTouchIdAuth = true;

          # Set Git commit hash for darwin-version.
          system.configurationRevision = self.rev or self.dirtyRev or null;

          # Used for backwards compatibility, please read the changelog before changing.
          # $ darwin-rebuild changelog
          system.stateVersion = 5;

          system.defaults = {
            dock.autohide = true;
            dock.autohide-delay = 0.0;
            dock.mru-spaces = false;
            finder.AppleShowAllExtensions = true;
            finder.FXPreferredViewStyle = "clmv";
            screencapture.location = "~/Pictures/screenshots";
            screensaver.askForPasswordDelay = 10;
            NSGlobalDomain.InitialKeyRepeat = 1;
            NSGlobalDomain.KeyRepeat = 1;
          };

          nixpkgs.hostPlatform = "aarch64-darwin";
          nixpkgs.overlays = [
            (final: prev: {
              sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
                pname = "sf-mono-liga-bin";
                version = "dev";
                src = inputs.sf-mono-liga-src;
                dontConfigure = true;
                installPhase = ''
                  mkdir -p $out/share/fonts/opentype
                  cp -R $src/*.otf $out/share/fonts/opentype/
                '';
              };
            })
          ];
        };
    in
    {
      # $ darwin-rebuild build --flake .#Victors-MacBook-Pro
      darwinConfigurations."Victors-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          configuration
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.victorwkb = import ./home.nix;
            home-manager.backupFileExtension = "backup";
          }
          nix-homebrew.darwinModules.nix-homebrew
          {
            nix-homebrew = {
              user = "victorwkb";
              enable = true;
              enableRosetta = true;
              autoMigrate = true;
              taps = {
                "homebrew/homebrew-core" = homebrew-core;
                "homebrew/homebrew-cask" = homebrew-cask;
              };
            };
          }
        ];

      };

      # Expose the package set, including overlays, for convenience.
      darwinPackages = self.darwinConfigurations."Victors-MacBook-Pro".pkgs;
    };
}
