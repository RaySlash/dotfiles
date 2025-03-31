{pkgs, ...}: {
  home.packages = with pkgs; [
    btop
    obsidian
    fd
    ripgrep
    lazygit
    unzip
    wget
    imv
    helvum
    openrgb-with-all-plugins
    libreoffice-fresh
    stremio
    # wineWowPackages.waylandFull
    virt-manager
    vlc
    vesktop
    prismlauncher
  ];

  custom = {
    programs = {
      firefox.enable = true;
      kitty.enable = true;
      hyprland.enable = true;
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
  };
  dconf.settings = {
    "org/virt-manager/virt-manager/connections" = {
      autoconnect = ["qemu:///system"];
      uris = ["qemu:///system"];
    };
  };
  home.stateVersion = "23.05";
}
