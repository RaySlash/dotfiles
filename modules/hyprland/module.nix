{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.hyprland;
in {
  options.custom.hyprland = {enable = mkEnableOption "hyprland";};

  config = mkIf cfg.enable {
    services = {
      dbus.enable = mkDefault true;
      gvfs.enable = mkDefault true;
      tumbler.enable = mkDefault true;
      hypridle.enable = mkDefault true;
      gnome.gnome-keyring.enable = mkDefault true;
      displayManager.defaultSession = mkDefault "hyprland";
      xserver.displayManager.gdm = {
        enable = mkDefault true;
        wayland = mkDefault true;
      };
    };

    hardware.graphics.enable = mkDefault true;

    programs = mkDefault {
      hyprlock.enable = mkDefault true;
      hyprland = mkDefault {
        enable = mkDefault true;
        systemd.setPath.enable = mkDefault true;
      };
    };

    environment = mkDefault {sessionVariables.NIXOS_OZONE_WL = "1";};

    xdg.portal.extraPortals = mkDefault (with pkgs; [xdg-desktop-portal-gtk]);
  };
}
