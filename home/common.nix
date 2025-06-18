{
  pkgs,
  inputs,
  lib,
  hub,
  ...
}: {
  imports = [
    inputs.stylix.homeModules.stylix
    inputs.nix-index-database.hmModules.nix-index
  ];

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
    iconTheme = {
      light = "Papirus-Light";
      dark = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
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
        desktop = 13;
        applications = 13;
        popups = 13;
        terminal = 13;
      };
    };
    targets = {
      emacs.enable = false;
      gtk.enable = true;
    };
  };

  programs = {
    gpg.enable = true;
    git = {
      enable = true;
      userEmail = hub.cfg.user.email;
      userName = hub.cfg.user.name;
    };
  };

  home = {
    username = hub.cfg.user.name;
    homeDirectory = lib.mkDefault (lib.concatStrings ["/home/" hub.cfg.user.name]);
  };

  custom = {
    programs.bash.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
