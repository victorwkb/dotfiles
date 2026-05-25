# dotfiles

Personal dotfiles managed with Nix, home-manager, and git submodules.

## Structure

```
dotfiles/
├── flake.nix              # Unified root flake — darwin + nixos-wsl
├── flake.lock
├── hosts/
│   ├── darwin/
│   │   ├── default.nix   # System config: packages, homebrew, system.defaults, overlays
│   │   └── home.nix      # home-manager for victorwkb (/Users/victorwkb)
│   └── nixos-wsl/
│       ├── default.nix   # System config: NixOS, WSL module, packages, overlays
│       └── home.nix      # home-manager for vicwkb (/home/vicwkb)
├── modules/
│   └── home/             # Shared home-manager modules (both hosts import these)
│       ├── carapace.nix, git.nix, kitty.nix, nushell.nix, starship.nix
│       └── tmux.nix, vscode.nix, yazi.nix, zoxide.nix, zsh.nix
├── overlays/
│   └── default.nix       # sf-mono-liga-bin (shared); darwin adds claude-code overlay
├── .github/workflows/
│   └── ci.yml            # nix flake check on macos-latest + ubuntu-latest
├── nvim/                 # git submodule → github:victorwkb/init.lua
└── .config/              # Non-nix dotfiles (aerospace, ghostty, kitty, tmux, zsh)
```

## Hosts

| Host | Config name | User | Platform |
|------|-------------|------|----------|
| Victors-MacBook-Pro | `darwinConfigurations."Victors-MacBook-Pro"` | `victorwkb` | aarch64-darwin |
| nixos (WSL) | `nixosConfigurations.nixos` | `vicwkb` | x86_64-linux |

## Apply commands

**macOS (nix-darwin):**
```sh
sudo darwin-rebuild switch --flake ~/dotfiles#Victors-MacBook-Pro
```

**NixOS WSL:**
```sh
sudo nixos-rebuild switch --flake ~/dotfiles#nixos
```

**From GitHub (macOS):**
```sh
sudo darwin-rebuild switch --flake 'github:victorwkb/dotfiles#Victors-MacBook-Pro'
```

## Key notes

- darwin-only: homebrew (aerospace, jordanbaird-ice), nix-homebrew, claude-code overlay, cloud SDKs (aws, gcp).
- WSL-only: build toolchain (gcc, cmake, clang), nix-ld, xserver, direnv, uv.
- Shared overlay: sf-mono-liga-bin (`overlays/default.nix`), receives `inputs` via `specialArgs`.
- Usernames differ: `victorwkb` (darwin) vs `vicwkb` (WSL).
- nixpkgs channel: `nixos-unstable` for both hosts.
- nvim config is a separate submodule, symlinked into place via `mkOutOfStoreSymlink`.
