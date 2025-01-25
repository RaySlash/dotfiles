{
  config,
  pkgs,
  ...
}: {
  programs = {
    gpg.enable = true;
    git.enable = true;
  };

  # Nixcat hmModule
  nvimcat = {
    enable = true;
    packageNames = ["nvimcat"];
  };

  custom = {
    nix-addons.enable = true;
    users.smj.enable = true;
  };

  systemd.user.startServices = "sd-switch";
}
