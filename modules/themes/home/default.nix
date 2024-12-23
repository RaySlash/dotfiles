{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.themes-addons;
in {
  options.custom.themes-addons = {enable = mkEnableOption "themes-addons";};

  config = mkIf cfg.enable {
    gtk = {
      enable = true;
      cursorTheme = {
        name = "macOS-White";
        package = pkgs.apple-cursor;
        size = 32;
      };
      iconTheme = {
        name = "Papirus-Dark";
        package = pkgs.papirus-icon-theme;
      };
      font = {
        name = "IosevkaTerm Nerd Font";
        size = 12;
      };
      theme = {
        name = "Kanagawa-BL";
        package = pkgs.kanagawa-gtk-theme;
      };
    };

    home = {
      pointerCursor = {
        gtk.enable = true;
        x11 = {
          enable = true;
          defaultCursor = "X_cursor";
        };
        name = "macOS-White";
        package = pkgs.apple-cursor;
        size = 32;
      };

      packages = with pkgs; [papirus-icon-theme];
    };
  };
}
