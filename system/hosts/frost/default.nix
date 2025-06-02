{
  pkgs,
  inputs,
  config,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    inputs.lanzaboote.nixosModules.lanzaboote
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
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["i2c-dev" "hid-tmff2"];
    blacklistedKernelModules = ["hid-thrustmaster"];
    extraModulePackages = with config.boot.kernelPackages; [hid-tmff2];
    # supportedFilesystems = ["ntfs"];
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = false;
        # configurationLimit = 8;
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

  services.guix = {
    enable = true;
    publish.enable = true;
  };

  programs = {
    kdeconnect.enable = true;
    dconf.enable = true;
    adb.enable = true;
    steam = {
      enable = true;
      # extest.enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--adaptive-sync" # VRR support
          "--mangoapp" # performance overlay
          "--rt"
          "--steam"
        ];
      };
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraEnv = {
          MANGOHUD = true;
          OBS_VKCAPTURE = true;
          # RADV_TEX_ANISO = 16;
        };
        extraLibraries = p:
          with p; [
            atk
          ];
      };
      extraCompatPackages = with pkgs; [proton-ge-bin];
      extraPackages = with pkgs; [
        gamescope
        mangohud
      ];
    };
  };

  custom = {
    profiles = {
      desktop.enable = true;
      themes.enable = true;
    };
    programs = {
      hyprland.enable = true;
      minecraft-servers.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      man-pages
      man-pages-posix
      sbctl
      home-manager-master
    ];
  };

  system.stateVersion = "23.05";
}
