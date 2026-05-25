{ pkgs, ... }:
{
  nixpkgs.config.allowUnfree = true;
  nix.settings.experimental-features = "nix-command flakes";

  environment.systemPackages = [
    pkgs.git
    pkgs.vim
    pkgs.wget
    pkgs.curl
  ];

  security.sudo.wheelNeedsPassword = false;
  users.mutableUsers = true;

  users.users.nixos = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };

  users.users.vicwkb = {
    isNormalUser = true;
    group = "vicwkb";
    extraGroups = [ "wheel" ];
    initialPassword = "nixos";
  };
  users.groups.vicwkb = { };
}
