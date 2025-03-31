{
  pkgs,
  localConfig,
  lib,
  inputs,
  ...
}: {
  systemd.extraConfig = "\n    DefaultTimeoutStopSec=10s\n    ";
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";
  networking = {
    networkmanager.enable = true;
    firewall = {
      enable = true;
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
  programs.git.enable = true;

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
