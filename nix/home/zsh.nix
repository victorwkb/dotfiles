{ pkgs, ... }:
{
  enable = true;
  initContent = ''
    # Add any additional configurations here
    export PATH=/run/current-system/sw/bin:$HOME/.nix-profile/bin:$PATH
    if [ -e '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh' ]; then
      . '/nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh'
    fi
  '';
}
