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

  # Marker read by bootstrap-wsl.sh to know Stage 1 is done and proceed to Stage 2.
  # Absent from the full #nixos config, so it disappears after the Stage 2 rebuild.
  environment.etc."nixos-bootstrap-stage1-done".text = "done";
}
