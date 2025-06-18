{
  pkgs,
  hub,
  lib,
  inputs,
  config,
  ...
}: {
  imports = [
    inputs.stylix.nixosModules.stylix
    inputs.nix-minecraft.nixosModules.minecraft-servers
  ];
  systemd.extraConfig = "\n    DefaultTimeoutStopSec=10s\n    ";
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
    };
  };

  stylix = {
    enable = true;
    base16Scheme = "${inputs.tt-schemes}/base16/kanagawa-dragon.yaml";
    image = ../docs/wallpaper.jpg;
    polarity = "dark";
    cursor = {
      name = "macOS-White";
      package = pkgs.apple-cursor;
      size = 32;
    };
    opacity = {
      terminal = 0.9;
    };
    fonts = {
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font";
      };
      serif = config.stylix.fonts.sansSerif;
      monospace = config.stylix.fonts.sansSerif;
      sizes = {
        desktop = 13;
        applications = 13;
        popups = 13;
        terminal = 13;
      };
    };
    targets = {
      gtk.enable = true;
    };
  };

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
    };
  };

  boot.tmp.cleanOnBoot = true;
  security.polkit.enable = true;
  programs = {
    git.enable = true;
    # ssh.startAgent = true;
    wireshark = {
      enable = true;
      dumpcap.enable = true;
      usbmon.enable = true;
    };
  };

  custom = {
    programs = {
      bash.enable = true;
      nix.enable = true;
    };
    # profiles = {
    # };
  };

  documentation = {
    dev.enable = true;
    man.enable = true;
  };

  users.users = let
    username = hub.cfg.user.name;
  in {
    ${username} = {
      name = username;
      isNormalUser = true;
      createHome = true;
      home = "/home/${username}";
      initialHashedPassword = hub.cfg.user.initialHashedPassword;
      extraGroups = ["wheel" "podman" "docker" "audio" "video" "networkmanager" "wireshark" "adbusers"];
      shell = pkgs.bash;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      gcc
      gnumake
      pciutils
      vulkan-tools
      glxinfo
      lshw
    ];
  };
}
