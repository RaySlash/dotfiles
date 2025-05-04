{
  pkgs,
  inputs,
  lib,
  hub,
  ...
}: {
  imports = [
    inputs.stylix.homeManagerModules.stylix
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
      terminal = 0.8;
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
        desktop = 12;
        applications = 12;
        popups = 12;
        terminal = 12;
      };
    };
    targets = {
      kitty.variant256Colors = true;
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

  # Nixcat hmModule
  nvimcat = {
    enable = true;
    packageNames = ["nvimcat"];
  };

  custom = {
    profiles.development.enable = true;
    programs.nushell.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
