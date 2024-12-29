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
          nixpkgs.config.allowUnfree = true;
          # List packages installed in system profile. To searchby name, run:
          # $ nix-env -qaP | grep wget
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
            # pkgs.kitty
            pkgs.lazygit
            pkgs.neovim
            pkgs.nodejs_22
            pkgs.carapace
            pkgs.nushell
            pkgs.nu_scripts
            pkgs.ripgrep
            pkgs.vim
            pkgs.tmux
            pkgs.wget
            # Languages
            pkgs.terraform
            pkgs.nil
            pkgs.nixfmt-rfc-style
            pkgs.poetry
          ];

          users.users.victorwkb = {
            name = "victorwkb";
            home = "/Users/victorwkb";
          };

          homebrew = {
            enable = true;
            brews = [
              "mas"
            ];
            casks = [
              "aerospace"
              "ghostty"
              "jordanbaird-ice"
              "font-sf-mono"
            ];
            masApps = {
            };
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
            NSGlobalDomain.InitialKeyRepeat = 10;
            NSGlobalDomain.KeyRepeat = 3;
          };

          security.pam.enableSudoTouchIdAuth = true;

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
              enable = true;
              enableRosetta = true;
              user = "victorwkb";
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
