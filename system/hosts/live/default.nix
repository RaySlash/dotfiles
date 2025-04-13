{
  config,
  pkgs,
  ...
}: {
  services = {
    openssh.enable = true;
    xserver = {
      enable = true;
      xkb = {
        layout = "us";
        variant = "";
      };
      excludePackages = [pkgs.xterm];
      displayManager.gdm.enable = true;
      desktopManager.xfce.enable = true;
    };
  };

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

  nvimcat = {
    enable = true;
    packageNames = ["nvim-minimal"];
  };

  programs = {
    firefox = {
      enable = true;
      package = pkgs.firefox-bin;
      policies = {
        "DisableTelemetry" = true;
        "DisableAppUpdate" = true;
        "DisableFirefoxAccounts" = true;
        "DisablePocket" = true;
      };
    };
  };

  custom = {
    profiles = {
      development.enable = true;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      coreutils
      pciutils
      btrfs-progs
      lshw
      nmap
      git
      kitty
    ];
  };

  system.stateVersion = "25.05";
}
