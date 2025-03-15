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
    # nativeSystemd = true;
    wslConf = {
      automount.enabled = true;
      automount.root = "/mnt";
    };
  };

  nixpkgs.hostPlatform = {system = "x86_64-linux";};
  networking.hostName = "wsl";

  programs = {
  };

  virtualisation = {
    podman = {
      enable = true;
      dockerCompat = true;
      dockerSocket.enable = true;
      autoPrune.enable = true;
    };
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
