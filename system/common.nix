{
  pkgs,
  localConfig,
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
      terminal = 0.8;
    };
    fonts = {
      serif = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font";
      };
      sansSerif = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font";
      };
      monospace = {
        package = pkgs.nerd-fonts.iosevka-term;
        name = "IosevkaTerm Nerd Font";
      };
      sizes = {
        desktop = 12;
        applications = 12;
        popups = 12;
        terminal = 12;
      };
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
  };

  custom = {
    programs = {
      zsh.enable = true;
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
    username = localConfig.username;
  in {
    ${username} = {
      name = username;
      isNormalUser = true;
      createHome = true;
      home = "/home/${username}";
      initialHashedPassword = "$y$j9T$OHE2L5aEqg6F0WtDdHIML0$6Qnd4f.HFzL3n3k8w1QYyR5MC/z8SL.0gQwIjLNML5/"; # 0000
      extraGroups = ["wheel" "podman" "docker" "audio" "video" "networkmanager"];
      shell = pkgs.zsh;
    };
  };

  environment = {
    systemPackages = with pkgs; [
      eza
      libclang
      gcc
      gnumake
    ];
  };
}
