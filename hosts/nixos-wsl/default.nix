{ pkgs, inputs, ... }:
{
  imports = [ ../../modules/system/common.nix ];

  environment.systemPackages = [
    pkgs.tmux
    pkgs.direnv
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

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = true;

  users.users.vicwkb = {
    isNormalUser = true;
    group = "vicwkb";
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
    shell = pkgs.zsh;
  };
  users.groups.vicwkb = { };

  nixpkgs.overlays = import ../../overlays/default.nix { inherit inputs; };
}
