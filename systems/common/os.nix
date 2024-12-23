{pkgs, ...}: {
  networking.networkmanager.enable = true;
  systemd.extraConfig = "\n    DefaultTimeoutStopSec=10s\n    ";
  time.timeZone = "Australia/Brisbane";
  i18n.defaultLocale = "en_AU.UTF-8";

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
    zsh.enable = true;
    nix.enable = true;
    themes.enable = true;
    users.smj.enable = true;
  };

  documentation = {
    dev.enable = true;
    man = {
      enable = true;
      # generateCaches = true;
    };
  };

  environment = {systemPackages = with pkgs; [eza libclang gcc gnumake];};
}
