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

  users.users.vicwkb = {
    isNormalUser = true;
    group = "vicwkb";
    extraGroups = [ "wheel" ];
    password = "";
  };
  users.groups.vicwkb = { };

  nixpkgs.overlays = import ../../overlays/default.nix { inherit inputs; };
}
