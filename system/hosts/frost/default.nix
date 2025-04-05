{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];

  networking = {
    hostName = "frost";
    nftables.enable = true;
    # firewall = {
    # allowedTCPPorts = [25565];
    # allowedUDPPorts = [25565];
    # };
  };

  boot = {
    # kernelPackages = pkgs.linuxPackages_xanmod;
    kernelModules = ["i2c-dev"];
    supportedFilesystems = ["ntfs"];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
        configurationLimit = 8;
      };
    };
  };

  hardware = {
    xone.enable = true;
    graphics.enable32Bit = true;
  };

  services = {
    udev.packages = with pkgs; [openrgb-with-all-plugins];
    fstrim.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };
    # xserver = {
    #   enable = true;
    #   excludePackages = [pkgs.xterm];
    # displayManager.lightdm.enable = false;
    #   xkb = {
    #     layout = "us";
    #     variant = "";
    #   };
    # };
  };

  virtualisation = {
    # podman = {
    #   enable = true;
    #   dockerCompat = true;
    #   dockerSocket.enable = true;
    #   autoPrune.enable = true;
    # };
    libvirtd = {
      enable = true;
      qemu.swtpm.enable = true;
    };
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  programs = {
    kdeconnect.enable = true;
    dconf.enable = true;
  };

  custom = {
    profiles = {
      desktop.enable = true;
      development.enable = true;
      themes.enable = true;
    };
    programs = {
      hyprland.enable = true;
      yazi.enable = true;
      minecraft-servers.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs;
      [
        man-pages
        man-pages-posix
      ]
      ++ [inputs.home-manager.packages.${pkgs.system}.home-manager];
  };

  system.stateVersion = "23.05";
}
