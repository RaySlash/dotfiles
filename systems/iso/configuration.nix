{
  config,
  lib,
  pkgs,
  ...
}: {
  services = {
    openssh = {enable = true;};
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = [pkgs.xterm];
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };
  };

  # nixpkgs.hostPlatform = {system = "x86_64-linux";};

  boot = {
    initrd.kernelModules = ["wl"];
    kernelModules = ["wl"];
    extraModulePackages = with config.boot.kernelPackages; [broadcom_sta];
  };

  networking = {
    hostName = "nixos-live";
    wireless = {
      enable = false;
      iwd.enable = true;
    };
  };

  hardware.pulseaudio.enable = false;

  environment = {
    gnome.excludePackages = with pkgs; [
      gnome-photos
      gnome-music
      gnome-terminal
      gedit
      gnome-tour
      cheese # webcam tool
      epiphany # web browser
      geary # email reader
      evince # document viewer
      gnome-characters
      totem # video player
      tali # poker game
      iagno # go game
      hitori # sudoku game
      atomix # puzzle game
    ];
    systemPackages = with pkgs; [
      pciutils
      lshw
      btop
      networkmanager
      nmap
      btrfs-progs
      chromium
    ];
  };

  system.stateVersion = "23.11";
}
