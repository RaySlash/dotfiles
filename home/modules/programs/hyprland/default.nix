{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.hyprland;
in {
  options.custom.programs.hyprland = {
    enable = mkEnableOption "programs.hyprland";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = mkDefault true;
    };

    services = {
      cliphist.enable = mkDefault true;
      udiskie = {
        enable = mkDefault true;
        notify = mkDefault true;
        automount = mkDefault true;
        tray = mkDefault "auto";
      };
    };

    programs = {
      wlogout = {
        enable = mkDefault true;
      };
    };

    home = {
      packages = with pkgs; [
        hyprpolkitagent
        hyprsunset
        wl-clipboard
        wirelesstools
        libva-utils
        fuseiso
        gsettings-desktop-schemas
      ];
    };
  };
}
