# 🖥️ NixOS & Home-Manager Dotfiles

![NixOS](https://img.shields.io/badge/nixos-unstable?logo=nixos)
![Flakes](https://img.shields.io/badge/Flakes-Enabled-blueviolet)
![License](https://img.shields.io/badge/License-GPLv3-green)

My personal NixOS configuration featuring multiple hosts and modern development setups.

> **Warning**: These configs are highly opinionated - use as inspiration, not copy-paste!

## 🚀 Usage

### 🧩 Neovim Configuration

```bash
nix run github:rayslash/dotfiles#nvimcat
# OR use following for a minimal config
nix run github:rayslash/dotfiles#nvim-minimal
```

### 📀 Live ISO Generation

Build bootable ISO with `live` nixos host configuration:

```bash
nix build .#images.x86_64
nix build .#images.rpi-live
```

### 🛠️ System Installation

> **⚠️ Important**: Replace all `<host>` occurrences with your actual hostname.
> Same applies for `/dev/sdX` devices as well.

**Fresh Install Procedure:**

```bash
# Partitioning
sudo fdisk /dev/sdX  # Create required partitions
sudo mount /dev/sdXX /mnt  # Mount root partition
sudo mount /dev/sdXX /mnt/boot  # Mount boot
sudo mount /dev/sdXX /mnt/nix  # Mount nix

# Configuration Setup
git clone https://github.com/RaySlash/nixos-config /mnt/etc/nixos
rm /mnt/etc/nixos/systems/<host>/hardware-configuration.nix
sudo nixos-generate-config --root /mnt
sudo cp /mnt/etc/nixos/hardware-configuration.nix /mnt/etc/nixos/systems/<host>/

# Final Installation
sudo nixos-install --flake .#<host>
```

## 🧠 Philosophy

### Core Principles:

- 🔌 **Explicit Wiring**: Configurations are directly referenced via absolute paths - no implicit file tree crawling
- 📚 **Layered Composition**: Modules set defaults that can be cleanly overridden:

  ```nix
  # modules/kitty/default.nix
  { lib, ... }: {
    programs.kitty = {
      enable = lib.mkDefault true;  # Default that can be disabled
      defaultTerminal = lib.mkDefault true;
    };
  }

  # hosts/myhost/default.nix
  { lib, ... }: {
    programs.kitty = {
      # Explicit override of default
      defaultTerminal = false;
    };
  }
  ```

- 🧰 **Utility-First**: Abstract common patterns into repo-specific functions:

  ```nix
  # utils/lib.nix
  { inputs }:
  {
  inherit
    mkPkgs
    mkHome
    mkSystem
    ;
  }
  ```

- 🚫 **Anti-Pattern Rejection**:
  - No automatic inclusion of `./hosts/*.nix`
  - No magic "profiles" directory
  - No recursive config discovery (except when explicitly enabled)

### Zero-Magic Plug & Play Architecture:

```nix
# Anti-pattern vs Our Approach
# Instead of implicit path resolution:
./users/${user}/home.nix

# We use explicit composition:
mkHome {
  system = "x86_64-linux";
  modules = [ ./hosts/myhost ];
}
```

### Implementation Guardrails

1. **Host Declaration**:

   ```nix
   mkSystem {
     system = "aarch64-linux";
     modules = [
       ./hosts/myhost
       specialFeatureModule.default
     ];
   }
   ```

2. **Home-Manager Activation**:

   ```nix
   mkHome {
     user = "devuser";
     modules = [
       ./hosts/myhost
       customAliasesModule.myModule
     ];
   }
   ```

> "Configs should be obvious, not clever"
> i.e., Direct file references > Convention over configuration

## 🔗 Resources

- 🧩 **[Starter Config](https://github.com/Misterio77/nix-starter-configs)** - Flake template foundation
- 📦 **[Nixpkgs](https://github.com/NixOS/nixpkgs)** - Official package repository
- 📚 **[NixOS Wiki](https://nixos.wiki/)** - Community-maintained knowledge base
- 🖥️ **[Hyprland Wiki](https://wiki.hyprland.org/)** - Window manager documentation

## 🖼️ Screenshots

![Hyprland Desktop](./docs/ss_nvim.png)  
![Firefox Setup](./docs/ss_ff.png)
