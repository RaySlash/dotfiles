{
  config,
  lib,
  pkgs,
  inputs,
  ...
}:
let
  wine-bin = pkgs.wineWow64Packages.waylandFull;
  cachy-kernel = pkgs.cachyosKernels.linux-cachyos-latest.override {
    # inherit pname version src;
     lto = "none";
     processorOpt = "x86_64-v3";
     cpusched = "bore";
     hzTicks = "1000";
     autofdo = false;
     hardened = false;
     rt = false;
     autoModules = true;
    };
in
{
  imports = [
    ./hardware-configuration.nix
    inputs.nix-index-database.nixosModules.default
  ];

  nix =
    let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in
    {
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
      gc.automatic = true;
      registry = lib.mapAttrs (_: flake: { inherit flake; }) flakeInputs;
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
    binfmt.registrations."DOSWin" = {
      wrapInterpreterInShell = false;
      interpreter = wine-bin;
      recognitionType = "magic";
      offset = 0;
      magicOrExtension = "MZ";
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
    # kernelPackages = pkgs.linuxPackages_latest;
    kernelPackages = pkgs.linuxKernel.packagesFor cachy-kernel;

    kernelModules = [
      "i2c-dev"
      "hid-tmff2"
      "ntsync"
    ];
    blacklistedKernelModules = [ "hid-thrustmaster" ];
    extraModulePackages = with config.boot.kernelPackages; [ hid-tmff2 ];
  };

  networking = {
    hostName = "frost";
    nftables.enable = true;
    networkmanager.enable = true;
    firewall = {
      enable = true;
      allowedTCPPorts = [ 
        25565 #minecraft
        11000 #subnautica-nitrox
      ];
      allowedUDPPorts = [
        25565 #minecraft
        24454 #minecraft-voice
        11000 #subnautica-nitrox
      ];
    };
  };

  hardware = {
    enableAllFirmware = true;
    graphics.enable32Bit = true;
    xone.enable = true;
  };

  documentation = {
    dev.enable = true;
    man.enable = true;
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
    flatpak.enable = true;
    btrfs.autoScrub = {
      enable = true;
      interval = "monthly";
    };
    displayManager = {
      gdm.enable = true;
      defaultSession = "niri";
    };
    desktopManager.gnome.enable = true;
  };

  programs = {
    kdeconnect.enable = true;
    nix-index-database.comma.enable = true;
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    git = {
      enable = true;
      package = pkgs.customPackages.git;
    };
    nh = {
      enable = true;
      flake = "~/dotfiles";
    };
    gamemode.enable = true;
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
      # package = pkgs.steam.override {
      #   extraEnv = {
      #     # MANGOHUD = true;
      #     # OBS_VKCAPTURE = true;
      #     # RADV_TEX_ANISO = 16;
      #   };
      #   extraLibraries =
      #     p: with p; [
      #       atk
      #     ];
      # };
      extraCompatPackages = with pkgs; [ proton-ge-bin ];
      extraPackages = with pkgs; [
        gamescope
        gamemode
        mangohud
      ];
    };
    nix-ld = {
      enable = true;
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

  environment = {
    sessionVariables = {
      WINE_BIN = lib.getExe wine-bin;
      DOTNET_ROOT = "${pkgs.dotnet-sdk_9}/share/dotnet";
    };
    systemPackages = with pkgs; [
      man-pages
      man-pages-posix
      btop
      sbctl
      gcc
      clang
      gnumake
      unzip
      pciutils
      vulkan-tools
      android-tools
      mesa-demos
      lshw
      wget
    ];
  };

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
      zen-browser
      prismlauncher
      dotnet-sdk_9
      dotnet-runtime_9
      dotnet-sdk_10
      dotnet-runtime_10
      typst
      imv
      vlc
      qbittorrent
      retroarch-full
      pokemmo-installer
      godot
      sgdboop
      gnomeExtensions.appindicator
      gnomeExtensions.gsconnect
      customPackages.emacs
      (discord.override { withVencord = true; })
      openrgb-with-all-plugins
      onlyoffice-desktopeditors
    ];
  };

  custom = {
    niri.enable = true;
    zsh.enable = true;
  };

  system.stateVersion = "25.11";
}
