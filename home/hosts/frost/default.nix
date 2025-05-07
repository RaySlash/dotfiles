{
  inputs,
  pkgs,
  config,
  ...
}: {
  imports = [
  ];

  home.packages = with pkgs; [
    btop
    obsidian
    fd
    unzip
    imv
    helvum
    openrgb-with-all-plugins
    libreoffice-fresh
    stremio
    pwvucontrol
    swww
    grimblast
    yazi
    zen-browser
    # wineWowPackages.waylandFull
    virt-manager
    vlc
    vesktop
    prismlauncher
  ];

  wayland.windowManager.hyprland = {
    settings = import ./hyprland.nix;
  };

  services.kdeconnect = {
    enable = true;
    indicator = true;
  };

  custom = {
    programs = {
      # firefox.enable = true;
      # kitty.enable = true;
      emacs.enable = true;
      hyprland.enable = true;
      hypridle.enable = true;
      hyprlock.enable = true;
      dunst.enable = true;
      eww.enable = true;
      fuzzel.enable = true;
    };
    profiles = {
      themes.enable = true;
    };
  };

  programs = {
    obs-studio = {
      enable = true;
      plugins = with pkgs.obs-studio-plugins; [
        wlrobs
        obs-vaapi
        obs-vkcapture
        obs-gstreamer
        obs-pipewire-audio-capture
      ];
    };
    foot = {
      enable = true;
      server.enable = true;
    };
    bat = {
      enable = true;
      extraPackages = with pkgs.bat-extras; [
        batdiff
        batman
        batgrep
        batwatch
      ];
    };
    fzf = {
      enable = true;
      enableZshIntegration = true;
    };
  };

  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };

  home.stateVersion = "23.05";
}
