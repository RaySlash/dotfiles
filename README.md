# NixOS + Home-Manager dotfiles

This repository consists of my personal NixOS configuration files. This is a flake repository. You know what to do!

## Usage

### Neovim Configuration

To use the configuration of nvim at `modules/nvimcat` run this in a nix enabled system:

```shell
nix run github:rayslash/nixos-config#nvimcat
```

### Build Live-boot image

To build the ISO image corresponding to `iso` host use:

```shell
nix build .#nixosConfigurations.live.config.system.build.isoImage
```

### System Configuration

> **NOTE:** Replace `<host>` with accurate hostname.

**Clean Install:** Partition and mount root, nix, boot and home using `fdisk` and `mount`.

```shell
sudo fdisk /dev/sdX                 #Recommended /, /boot and /nix partitions. Optionally, /home
sudo mount /dev/sdXX                #Mount all filesystems to /mnt
git clone https://github.com/RaySlash/nixos-config && cd nixos-config
rm systems/<host>/hardware-configuration.nix
sudo nixos-generate-config --root /mnt
sudo cp /etc/nixos/hardware-configuration.nix nixos/<host>/
sudo nixos-install --flake .#<host>
```

## Reference

[github:Misterio77/nix-starter-config](https://github.com/Misterio77/nix-starter-configs)

[Nixpkgs](https://github.com/NixOS/nixpkgs)

[NixOS Wiki](https://nixos.wiki/)

[NixOS and Flakes book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/introduction-to-flakes)

[Hyprland Wiki](https://wiki.hyprland.org/)

## Images

![Hyprland setup Screenshot](./docs/ss_nvim.png)
![Hyprland](./docs/ss_ff.png)
