{
  description = "victorwkb dotfiles — unified flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

    nix-darwin.url = "github:LnL7/nix-darwin";
    nix-darwin.inputs.nixpkgs.follows = "nixpkgs";

    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

    # darwin-only inputs
    nix-homebrew.url = "github:zhaofengli/nix-homebrew";
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
    claude-code.url = "github:sadjow/claude-code-nix";

    # nixos-wsl inputs
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    ghostty.url = "github:ghostty-org/ghostty";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      nix-homebrew,
      homebrew-core,
      homebrew-cask,
      sf-mono-liga-src,
      claude-code,
      nixos-wsl,
      ghostty,
    }:
    {
      darwinConfigurations."Victors-MacBook-Pro" = nix-darwin.lib.darwinSystem {
        system = "aarch64-darwin";
        modules = [
          (
            { pkgs, ... }:
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
              system.configurationRevision = self.rev or self.dirtyRev or null;
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
              nixpkgs.overlays = [
                (final: prev: {
                  sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
                    pname = "sf-mono-liga-bin";
                    version = "dev";
                    src = sf-mono-liga-src;
                    dontConfigure = true;
                    installPhase = ''
                      mkdir -p $out/share/fonts/opentype
                      cp -R $src/*.otf $out/share/fonts/opentype/
                    '';
                  };
                })
                claude-code.overlays.default
              ];
            }
          )
          home-manager.darwinModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.victorwkb = import ./nix/nix-darwin/home.nix;
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

      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          (
            { pkgs, ... }:
            {
              nixpkgs.config.allowUnfree = true;

              environment.systemPackages = [
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
                pkgs.tmux
                pkgs.wget
                pkgs.nil
                pkgs.nixfmt-rfc-style
                pkgs.direnv
                pkgs.nix-ld-rs
                pkgs.gcc
                pkgs.gnumake
                pkgs.cmake
                pkgs.clang
                pkgs.uv
              ];

              environment.sessionVariables = {
                DISPLAY = ":0";
                WAYLAND_DISPLAY = "wayland-0";
                XDG_RUNTIME_DIR = "/mnt/wslg/runtime-dir";
              };

              programs.nix-ld.enable = true;
              programs.zsh.enable = true;
              services.xserver.enable = true;

              users.users.vicwkb = {
                isNormalUser = true;
                group = "vicwkb";
                extraGroups = [ "wheel" ];
                password = "";
              };
              users.groups.vicwkb = { };

              nix.settings.experimental-features = "nix-command flakes";

              nixpkgs.overlays = [
                (final: prev: {
                  sf-mono-liga-bin = prev.stdenvNoCC.mkDerivation {
                    pname = "sf-mono-liga-bin";
                    version = "dev";
                    src = sf-mono-liga-src;
                    dontConfigure = true;
                    installPhase = ''
                      mkdir -p $out/share/fonts/opentype
                      cp -R $src/*.otf $out/share/fonts/opentype/
                    '';
                  };
                })
              ];
            }
          )
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "25.05";
            wsl.enable = true;
            wsl.defaultUser = "vicwkb";
          }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vicwkb = import ./nix/nixos-wsl/home.nix;
          }
        ];
      };

      darwinPackages = self.darwinConfigurations."Victors-MacBook-Pro".pkgs;
      nixosPackages = self.nixosConfigurations.nixos.pkgs;
    };
}
