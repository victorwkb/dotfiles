{ pkgs, inputs, ... }:
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

  nixpkgs.overlays = import ../../overlays/default.nix { inherit inputs; };
}
