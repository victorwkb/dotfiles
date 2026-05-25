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
│   ├── shared.nix         # [planned] Common system config imported by both hosts
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

---

## Branch: feat/nixos-wsl

Consolidation of nix-darwin and nixos-wsl configs into a single unified flake. Not yet merged to main.

### Completed

| # | Step |
|---|------|
| 1 | Unified root `flake.nix` |
| 2 | `overlays/default.nix` — shared sf-mono-liga |
| 3 | `modules/home/` — shared home-manager modules, updated aliases |
| 4 | `hosts/darwin/` + `hosts/nixos-wsl/` — extracted host system configs |
| 5 | Rewired `flake.nix` to import from `hosts/` |
| 6 | Removed old `nix/` subdirectory |
| 7 | Updated `CLAUDE.md` |
| 8 | Added `.github/workflows/ci.yml` |

### Next: Package consolidation

Create `modules/shared.nix` — a NixOS/nix-darwin module abstracting what both hosts share:

**Will move to `modules/shared.nix`:**
- `nixpkgs.config.allowUnfree = true`
- `nix.settings.experimental-features = "nix-command flakes"`
- `programs.zsh.enable = true`
- Common packages: `bat eza fastfetch nerdfetch cbonsai cmatrix htop pipes fd fzf git lazygit neovim nodejs_22 carapace nushell nu_scripts ripgrep vim wget nil`

**Will stay darwin-only** (`hosts/darwin/default.nix`):
- `awscli google-cloud-sdk ghostty-bin claude-code nixfmt-rfc-style`
- homebrew, system.defaults, overlays

**Will stay WSL-only** (`hosts/nixos-wsl/default.nix`):
- `tmux direnv nix-ld-rs gcc gnumake cmake clang uv nixfmt-rfc-style`
- nix-ld, xserver, session variables

**Decision**: Standardise both hosts to `nixfmt-rfc-style` (modern RFC formatter; darwin currently uses the older `nixfmt`).

Steps:
1. Create `modules/shared.nix`
2. Import it in both `hosts/*/default.nix`, remove duplicated settings and packages
3. `nix flake check` after each host update
4. Commit, darwin rebuild, WSL rebuild
