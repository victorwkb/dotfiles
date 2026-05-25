# dotfiles

Personal dotfiles managed with Nix, home-manager, and git submodules.

Hosts: macOS (nix-darwin, `aarch64-darwin`) and NixOS-WSL (`x86_64-linux`).

---

## NixOS-WSL Bootstrap

Go from a fresh Windows machine to a fully configured NixOS-WSL environment.

### Prerequisites

- Windows 10/11 with WSL2 enabled
- Download the latest NixOS-WSL installer from:  
  https://github.com/nix-community/NixOS-WSL/releases  
  Get `nixos.wsl` (not the `.tar.gz`)

---

### Step 1 — Import NixOS-WSL

Run in **PowerShell**:

```powershell
wsl --install --from-file $env:USERPROFILE\Downloads\nixos.wsl
wsl -d NixOS
```

You will be logged in as the default `nixos` user.

---

### Step 2 — Run the bootstrap script

```sh
curl -fsSL https://raw.githubusercontent.com/victorwkb/dotfiles/main/scripts/bootstrap-wsl.sh | bash
```

This will:
1. Enable nix flakes by writing to `/root/.config/nix/nix.conf` (system `/etc/nix/nix.conf` is read-only on NixOS)
2. Run `nixos-rebuild switch --flake 'github:victorwkb/dotfiles/main#nixos'`

> **Note:** The first run fetches all flake inputs including large homebrew taps (unified flake). Expect several minutes.

When it completes, exit and re-launch WSL:

```powershell
wsl -d NixOS
```

You will now be logged in as `vicwkb`.

---

### Step 3 — Clone dotfiles locally

The GitHub bootstrap is complete but local rebuilds need the repo on disk:

```sh
git clone https://github.com/victorwkb/dotfiles.git ~/dotfiles
cd ~/dotfiles
git submodule update --init --recursive
```

From here use the shell aliases for rebuilds:

```sh
nrs   # sudo nixos-rebuild switch --flake ~/dotfiles#nixos
nrsm  # sudo nixos-rebuild switch --flake 'github:victorwkb/dotfiles/main#nixos'
```

---

### Step 4 — Verify

```sh
which nu && which nvim && which claude
git config user.name    # victorgoh-zen
git config user.email   # victor.goh@zenenergy.com.au
tmux new -s main        # tmux with nushell as default shell
```

---

### Known issues

| Issue | Explanation |
|-------|-------------|
| Long first fetch | `homebrew-core` and `homebrew-cask` are fetched even for WSL due to the unified flake. Normal. |
| nvim opens without config | The nvim symlink points to `~/dotfiles/nvim`. Dangling until Step 3 is done. nvim still works. |
| `SFMono Nerd Font Lig` not found in ghostty | Run `fc-cache -fv` after first rebuild to refresh the font cache. |
| `sudo` works without password | Intentional — `security.sudo.wheelNeedsPassword = false` is set for `vicwkb`. |
| Existing dotfiles renamed to `.backup` | `home-manager.backupFileExtension = "backup"` is set. Conflicting files are renamed rather than blocking the rebuild. |
