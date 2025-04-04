{
  inputs,
  pkgs,
  ...
}: {
  home.packages = with pkgs; [
    inputs.zen-browser.packages.${pkgs.system}.default
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
    pwvucontrol
    swww
    wlr-randr
    grim
    slurp
    coreutils
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
      kitty.enable = true;
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
