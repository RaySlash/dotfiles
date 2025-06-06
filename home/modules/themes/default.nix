{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.profiles.themes;
in {
  options.custom.profiles.themes = {enable = mkEnableOption "profiles.themes";};

  config = mkIf cfg.enable {
    gtk = {
      enable = mkDefault true;
      cursorTheme = {
        name = mkDefault "macOS-White";
        package = mkDefault pkgs.apple-cursor;
        size = mkDefault 32;
      };
      iconTheme = {
        name = mkDefault "Papirus-Dark";
        package = mkDefault pkgs.papirus-icon-theme;
      };
      font = {
        name = mkDefault "IosevkaTerm Nerd Font";
        size = mkDefault 12;
      };
      theme = {
        name = mkDefault "Kanagawa-BL";
        package = mkDefault pkgs.kanagawa-gtk-theme;
      };
    };

    home = {
      pointerCursor = {
        gtk.enable = mkDefault true;
        x11 = {
          enable = mkDefault true;
          defaultCursor = mkDefault "X_cursor";
        };
        name = mkDefault "macOS-White";
        package = mkDefault pkgs.apple-cursor;
        size = mkDefault 32;
      };

      packages = with pkgs; [papirus-icon-theme];
    };
  };
}
