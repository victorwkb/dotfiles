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

The script is self-guiding and runs in stages. Follow the instructions it prints after each run. Re-run the same command as prompted until it reports done.

> **Note:** The first run fetches all flake inputs including large homebrew taps (unified flake). Expect several minutes.  
> systemd may restart mid-rebuild and disconnect your session — this is expected. Just relaunch WSL and re-run the script.

---

### Step 3 — Verify

```sh
which nu && which nvim && which claude
git config user.name
git config user.email
tmux new -s main
```

From here use the shell aliases for future rebuilds:

```sh
nrs   # sudo nixos-rebuild switch --flake ~/dotfiles#nixos
nrsm  # sudo nixos-rebuild switch --flake 'github:victorwkb/dotfiles/main#nixos'
```
