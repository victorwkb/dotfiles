#!/usr/bin/env bash
set -euo pipefail

FLAKE="github:victorwkb/dotfiles/main"
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
    # SSH key setup — required for submodule clone (uses SSH URL)
    if [[ ! -f "$HOME/.ssh/id_ed25519" ]]; then
      echo "==> No SSH key found. Generating one..."
      mkdir -p "$HOME/.ssh"
      ssh-keygen -t ed25519 -f "$HOME/.ssh/id_ed25519" -N "" -C "$(hostname)"
    fi
    echo ""
    echo "==> Add this SSH public key to your GitHub account before continuing:"
    echo "    https://github.com/settings/ssh/new"
    echo ""
    cat "$HOME/.ssh/id_ed25519.pub"
    echo ""
    read -rp "    Press Enter once the key is added to GitHub..."
    echo ""
    echo "==> Verifying SSH access to GitHub..."
    ssh -T git@github.com 2>&1 | grep -q "successfully authenticated" || {
      echo "    SSH verification failed. Check that the key was added and try again."
      exit 1
    }
    echo ""
    echo "==> Stage 3: Cloning dotfiles..."
    git clone git@github.com:victorwkb/dotfiles.git "$DOTFILES_DIR"
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
  echo "    systemd may restart mid-rebuild and disconnect your session — this is expected."
  echo "    When ready, relaunch WSL and re-run this script to apply the full config."
  echo ""
  sudo touch "$STAGE1_MARKER"
  sudo nixos-rebuild switch --flake "${FLAKE}#nixos-bootstrap" || {
    sudo rm -f "$STAGE1_MARKER"
    exit 1
  }
  echo ""
  echo "==> Stage 1 complete."
  echo "    Run 'wsl --shutdown' in PowerShell, then relaunch and re-run this script."
fi
