#!/usr/bin/env bash
set -euo pipefail

FLAKE="github:victorwkb/dotfiles/fix/nixos-wsl-bootstrap"
STAGE1_MARKER="/var/lib/nixos-bootstrap-stage1-done"
DOTFILES_DIR="$HOME/dotfiles"

if [[ -f "$STAGE1_MARKER" ]]; then
  # Stage 2: apply full NixOS config
  echo "==> Stage 1 complete — applying full NixOS config..."
  echo "    (This fetches all flake inputs — expect several minutes)"
  echo ""
  sudo nixos-rebuild switch --flake "${FLAKE}#nixos"
  sudo rm -f "$STAGE1_MARKER"
  echo ""
  echo "==> Done! Re-run this script to clone dotfiles."

elif command -v nu &>/dev/null; then
  # Stage 3: clone dotfiles (full config is active, nushell is available)
  if [[ -d "$DOTFILES_DIR" ]]; then
    echo "==> Dotfiles already cloned at $DOTFILES_DIR. Nothing to do."
  else
    echo "==> Stage 3: Cloning dotfiles..."
    git clone https://github.com/victorwkb/dotfiles.git "$DOTFILES_DIR"
    cd "$DOTFILES_DIR"
    git submodule update --init --recursive
    echo ""
    echo "==> Done! Use 'nrs' or 'nrsm' for future rebuilds."
  fi

else
  # Stage 1: minimal bootstrap
  echo "==> Enabling nix flakes..."
  sudo mkdir -p /root/.config/nix
  echo 'extra-experimental-features = nix-command flakes' | sudo tee /root/.config/nix/nix.conf > /dev/null

  echo ""
  echo "==> Stage 1: Applying minimal bootstrap config..."
  echo "    systemd will restart mid-rebuild — your WSL session will disconnect."
  echo "    This is expected. When disconnected:"
  echo "      1. wsl --shutdown          (in PowerShell)"
  echo "      2. wsl -d NixOS            (relaunch)"
  echo "      3. Re-run this script      (applies full config)"
  echo ""
  sudo touch "$STAGE1_MARKER"
  sudo nixos-rebuild switch --flake "${FLAKE}#nixos-bootstrap" || {
    sudo rm -f "$STAGE1_MARKER"
    exit 1
  }
  echo ""
  echo "==> Stage 1 complete. Run 'wsl --shutdown', relaunch, then re-run this script."
fi
