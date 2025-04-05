{
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.nixos-wsl.nixosModules.default
  ];

  wsl = {
    enable = true;
    defaultUser = inputs.self.localConfig.username;
    startMenuLaunchers = true;
    useWindowsDriver = true;
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

  custom = {
    yazi.enable = true;
  };

  environment = {
    systemPackages = with pkgs; [man-pages man-pages-posix];
  };

  system.stateVersion = "24.05";
}
