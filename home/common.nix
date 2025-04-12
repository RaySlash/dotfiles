{
  pkgs,
  inputs,
  lib,
  localConfig,
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
      userEmail = localConfig.email;
      userName = localConfig.username;
    };
  };

  home = {
    username = localConfig.username;
    homeDirectory = lib.mkDefault (lib.concatStrings ["/home/" localConfig.username]);
  };

  # Nixcat hmModule
  nvimcat = {
    enable = true;
    packageNames = ["nvimcat"];
  };

  custom = {
    profiles.development.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
