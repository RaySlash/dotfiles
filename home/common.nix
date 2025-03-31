{
  pkgs,
  inputs,
  lib,
  localConfig,
  ...
}: let
in {
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
