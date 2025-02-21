{pkgs, ...}: {
  home.packages = with pkgs; [
    htop
    obsidian
    fd
    ripgrep
    lazygit
    unzip
    p7zip
    wget
    imv
    helvum
    openrgb-with-all-plugins
    chromium
    libreoffice-fresh
    stremio
    wineWowPackages.waylandFull
    vlc
    vesktop
    prismlauncher
  ];

  custom = {
    firefox.enable = true;
    kitty.enable = true;
    themes-addons.enable = true;
    hyprland-addons.enable = true;
    # neovide.enable = true;
    # emacs-addons.enable = true;
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
    java = {
      enable = true;
      package = pkgs.jdk23;
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
