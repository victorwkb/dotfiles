# dotfiles

Personal dotfiles managed with Nix, home-manager, and git submodules.

## Current structure

```
dotfiles/
├── flake.nix              # Unified root flake — darwin + nixos-wsl
├── flake.lock
├── nix/
│   ├── nix-darwin/
│   │   └── home.nix       # darwin home-manager config (victorwkb)
│   ├── nixos-wsl/
│   │   └── home.nix       # NixOS WSL home-manager config (vicwkb)
│   └── home/              # Shared home-manager modules (both hosts import these)
│       ├── carapace.nix, git.nix, kitty.nix, nushell.nix, starship.nix
│       └── tmux.nix, vscode.nix, yazi.nix, zoxide.nix, zsh.nix
├── nvim/                  # git submodule → github:victorwkb/init.lua
└── .config/               # Non-nix dotfiles (aerospace, ghostty, kitty, tmux, zsh)
```

> **Migration in progress** — consolidating into `hosts/`, `modules/home/`, and `overlays/`.
> See `~/.claude/plans/lovely-jumping-orbit.md` for the step-by-step plan.

## Target structure (in progress)

```
dotfiles/
├── flake.nix
├── flake.lock
├── hosts/
│   ├── darwin/
│   │   ├── default.nix   # system config: packages, homebrew, system.defaults, overlays
│   │   └── home.nix      # home-manager for victorwkb (/Users/victorwkb)
│   └── nixos-wsl/
│       ├── default.nix   # system config: NixOS, WSL module, packages, overlays
│       └── home.nix      # home-manager for vicwkb (/home/vicwkb)
├── modules/
│   └── home/             # Shared home-manager modules
├── overlays/
│   └── default.nix       # sf-mono-liga-bin (shared); darwin adds claude-code overlay
├── .github/workflows/
│   └── ci.yml
├── nvim/
└── .config/
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

- Root `flake.nix` is the single entry point for both hosts.
- Both hosts share `nix/home/` modules (moving to `modules/home/` as part of migration).
- darwin-only: homebrew (aerospace, jordanbaird-ice), nix-homebrew, claude-code overlay, cloud SDKs (aws, gcp).
- WSL-only: build toolchain (gcc, cmake, clang), nix-ld, xserver, direnv, uv.
- Shared overlay: sf-mono-liga-bin (currently inline in `flake.nix`, moving to `overlays/`).
- The nvim config lives in a separate submodule; symlinked via `mkOutOfStoreSymlink`.
- Usernames differ: `victorwkb` (darwin) vs `vicwkb` (WSL).
- nixpkgs channel: `nixos-unstable` for both hosts.
