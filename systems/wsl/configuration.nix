{
  pkgs,
  inputs,
  ...
}: {
  imports = [];

  wsl = {
    enable = true;
    defaultUser = "smj";
    startMenuLaunchers = true;
    wslConf = {
      automount.enabled = true;
      automount.root = "/mnt";
    };
  };

  nixpkgs.hostPlatform = {system = "x86_64-linux";};
  networking = {
    hostName = "wsl";
  };

  hardware = {
    graphics.enable32Bit = true;
  };

  programs = {
    dconf.enable = true;
    xwayland.enable = true;
  };

  services = {
    dbus.enable = true;
    gnome.gnome-keyring.enable = true;
  };

  qt = {
    enable = true;
    platformTheme = "qt5ct";
  };

  custom = {
    yazi.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [man-pages man-pages-posix];
  };

  system.stateVersion = "24.05";
}
