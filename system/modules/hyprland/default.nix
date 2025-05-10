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
  options.custom.programs.hyprland = {enable = mkEnableOption "programs.hyprland";};

  config = mkIf cfg.enable {
    services = {
      dbus.enable = mkDefault true;
      gvfs.enable = mkDefault true;
      tumbler.enable = mkDefault true;
      hypridle.enable = mkDefault true;
      gnome.gnome-keyring.enable = mkDefault true;
      xserver.enable = mkDefault true;
      displayManager.defaultSession = mkDefault "hyprland";
      xserver.displayManager.lightdm = {
        enable = mkDefault true;
        greeters.gtk.enable = true;
      };
    };

    hardware.graphics.enable = mkDefault true;

    programs = {
      hyprlock.enable = mkDefault true;
      hyprland = {
        enable = mkDefault true;
        systemd.setPath.enable = mkDefault true;
      };
    };

    environment = mkDefault {
      sessionVariables.NIXOS_OZONE_WL = "1";
    };

    xdg.portal.extraPortals = with pkgs; [xdg-desktop-portal-gtk];
  };
}
