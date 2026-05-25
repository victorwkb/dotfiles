#!/usr/bin/env bash
set -euo pipefail

echo "==> Enabling nix flakes..."
sudo sh -c 'echo "extra-experimental-features = nix-command flakes" >> /etc/nix/nix.conf'

echo "==> Switching to dotfiles config from GitHub..."
echo "    (First run fetches all flake inputs — expect several minutes)"
sudo nixos-rebuild switch --flake 'github:victorwkb/dotfiles/main#nixos'

echo ""
echo "==> Bootstrap complete!"
echo "    Exit WSL and re-launch to log in as vicwkb:"
echo "    wsl -d NixOS"
