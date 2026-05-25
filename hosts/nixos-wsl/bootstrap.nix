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

  users.mutableUsers = true;
}
