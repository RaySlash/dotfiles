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
    firewall = {
      allowedTCPPorts = [];
      allowedUDPPorts = [];
    };
  };

  boot = {
    kernelPackages = pkgs.linuxPackages_zen;
    kernelModules = ["i2c-dev" "hid-tmff2" "ntsync"];
    blacklistedKernelModules = ["hid-thrustmaster"];
    extraModulePackages = with config.boot.kernelPackages; [hid-tmff2];
    lanzaboote = {
      enable = true;
      pkiBundle = "/var/lib/sbctl";
    };
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = false;
        configurationLimit = 8;
      };
    };
    kernel.sysctl = {
      # 20-shed.conf
      "kernel.sched_cfs_bandwidth_slice_us" = 3000;
      # 20-net-timeout.conf
      # This is required due to some games being unable to reuse their TCP ports
      # if they're killed and restarted quickly - the default timeout is too large.
      "net.ipv4.tcp_fin_timeout" = 5;
      # 30-splitlock.conf
      # Prevents intentional slowdowns in case games experience split locks
      # This is valid for kernels v6.0+
      "kernel.split_lock_mitigate" = 0;
      # 30-vm.conf
      # USE MAX_INT - MAPCOUNT_ELF_CORE_MARGIN.
      # see comment in include/linux/mm.h in the kernel tree.
      "vm.max_map_count" = 2147483642;
    };
  };

  hardware = {
    xone.enable = true;
    enableAllFirmware = true;
    graphics.enable32Bit = true;
  };

  services = {
    udev.packages = with pkgs; [
      openrgb-with-all-plugins
      (pkgs.writeTextFile {
        name = "ntsync-udev-rules";
        text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
        destination = "/etc/udev/rules.d/70-ntsync.rules";
      })
    ];
    fstrim.enable = true;
    factorio = {
      enable = true;
      package = pkgs.factorio-headless;
      lan = true;
      openFirewall = true;
      loadLatestSave = true;
      requireUserVerification = false;
      game-name = "Depressed Tech";
      mods = with pkgs; [];
      extraSettings = {
        max_players = 64;
      };
    };
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
