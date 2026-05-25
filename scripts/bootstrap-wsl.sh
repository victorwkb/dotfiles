#!/usr/bin/env bash
set -euo pipefail

echo "==> Enabling nix flakes..."
sudo mkdir -p /root/.config/nix
echo 'extra-experimental-features = nix-command flakes' | sudo tee /root/.config/nix/nix.conf > /dev/null

echo "==> Applying minimal bootstrap config from GitHub..."
echo "    (First run fetches all flake inputs — expect several minutes)"
sudo nixos-rebuild switch --flake 'github:victorwkb/dotfiles/fix/nixos-wsl-bootstrap#nixos-bootstrap'

echo ""
echo "==> Bootstrap complete!"
echo "    Exit WSL and re-launch to log in as vicwkb:"
echo "    wsl -d NixOS"
echo ""
echo "    Then clone dotfiles and run: nrsm"
echo "    to upgrade to the full config."
