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
      desktopManager.xfce.enable = true;
    };
    displayManager.gdm.enable = true;
  };

  boot = {
    initrd.kernelModules = ["wl"];
    kernelModules = ["wl"];
    extraModulePackages = with config.boot.kernelPackages; [broadcom_sta];
  };

  networking = {
    hostName = "nixos-live";
    # wireless = {
    #   enable = false;
    #   iwd.enable = true;
    # };
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

  environment = {
    systemPackages = with pkgs; [
      coreutils
      pciutils
      btrfs-progs
      lshw
      nmap
      git
      kitty
      vim
    ];
  };

  system.stateVersion = "25.05";
}
