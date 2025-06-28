{
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    nixos-wsl.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    ghostty = {
      url = "github:ghostty-org/ghostty";
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
      nixos-wsl,
      home-manager,
      ghostty,
      sf-mono-liga-src,
      ...
    }:
    let
      configuration =
        { pkgs, ... }:
        {
          nixpkgs.config.allowUnfree = true;
          # List packages installed in system profile. To searchby name, run:
          # $ nix-env -qaP | grep wget
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
          ];

          programs.nix-ld.enable = true;
          programs.zsh.enable = true;

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
      nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          nixos-wsl.nixosModules.default
          {
            system.stateVersion = "24.05";
            wsl.enable = true;
            wsl.defaultUser = "vicwkb";
          }
          configuration
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.vicwkb = import ./home.nix;
          }
        ];
      };
      nixosPackages = self.nixosConfigurations."Zen-HP".pkgs;
    };
}
