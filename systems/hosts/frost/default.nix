{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
  ];

  documentation = {
    dev.enable = true;
    man.enable = true;
  };

  nix = let
    flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
  in {
    settings = {
      experimental-features = "nix-command flakes";
      # flake-registry =  "";
      nix-path = config.nix.nixPath;
      auto-optimise-store = true;
      substituters = [
        "https://nix-community.cachix.org"
        "https://cache.nixos.org/"
      ];
      trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      ];
    };
    channel.enable = false;
    optimise.automatic = true;
    registry = lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs;
    nixPath = lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs;
  };

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot = {
        enable = true;
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
    tmp.cleanOnBoot = true;
    kernelPackages = pkgs.linuxPackages_latest;
    kernelModules = ["i2c-dev" "hid-tmff2" "ntsync"];
    blacklistedKernelModules = ["hid-thrustmaster"];
    extraModulePackages = with config.boot.kernelPackages; [hid-tmff2];
  };

  networking = {
    hostName = "frost";
    nftables.enable = true;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      # allowedTCPPorts = ["25565"];
      # allowedUDPPorts = ["25565"];
    };
  };

  hardware = {
    enableAllFirmware = true;
    graphics.enable32Bit = true;
  };

  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };

  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_US.UTF-8";
  security.polkit.enable = true;

  services = {
    udev.packages = with pkgs; [
      openrgb-with-all-plugins
      (pkgs.writeTextFile {
        name = "ntsync-udev-rules";
        text = ''KERNEL=="ntsync", MODE="0660", TAG+="uaccess"'';
        destination = "/etc/udev/rules.d/70-ntsync.rules";
      })
    ];
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
    printing.enable = true;
    fstrim.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };
    displayManager.gdm.enable = true;
    desktopManager.gnome.enable = true;
  };

  programs = {
    kdeconnect.enable = true;
    dconf.enable = true;
    git.enable = true;
    steam = {
      enable = true;
      gamescopeSession = {
        enable = true;
        args = [
          "--adaptive-sync" # VRR support
          # "--mangoapp" # performance overlay
          "--rt"
          "--steam"
        ];
      };
      protontricks.enable = true;
      remotePlay.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      package = pkgs.steam.override {
        extraEnv = {
          # MANGOHUD = true;
          # OBS_VKCAPTURE = true;
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
    nix-ld = {
      enable = true;
      package = pkgs.nix-ld;
      libraries = with pkgs; [
        alsa-lib
          at-spi2-atk
          at-spi2-core
          atk
          cairo
          cups
          curl
          dbus
          expat
          fontconfig
          freetype
          fuse3
          gdk-pixbuf
          glib
          gtk3
          icu
          libGL
          libappindicator-gtk3
          libdrm
          libglvnd
          libnotify
          libpulseaudio
          libunwind
          libusb1
          libuuid
          libxkbcommon
          libxml2
          mesa
          nspr
          nss
          openssl
          pango
          pipewire
          sqlite
          stdenv.cc.cc
          systemd
          vulkan-loader
          libX11
          libXScrnSaver
          libXcomposite
          libXcursor
          libXdamage
          libXext
          libXfixes
          libXi
          libXrandr
          libXrender
          libXtst
          libxcb
          libxkbfile
          libxshmfence
          zlib
          ];
    };
  };

  environment.pathsToLink = ["/share/zsh"];
  environment.systemPackages = with pkgs; [
    man-pages
    man-pages-posix
    sbctl
    gcc
    gnumake
    pciutils
    vulkan-tools
    android-tools
    mesa-demos
    lshw
    wget
    coreutils-full
  ];

  users.users.smj = {
    shell = pkgs.customPackages.zsh;
    isNormalUser = true;
    extraGroups = [
      "wheel"
      "podman"
      "docker"
      "audio"
      "video"
      "networkmanager"
      "wireshark"
      "adbusers"
    ];
    packages = with pkgs; [
      neovim
      zen-browser
      nerd-fonts.iosevka
      emacs-pgtk
      alejandra
      nil
      nixd
    ];
  };

  custom.zsh.enable = true;

  system.stateVersion = "25.11";
}
