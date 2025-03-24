{
  inputs,
  outputs,
  pkgs,
  ...
}: {
  imports = [
    inputs.home-manager.nixosModules.home-manager
    inputs.nixos-hardware.nixosModules.raspberry-pi-4

    ./hardware-configuration.nix
  ];

  networking.hostName = "rpi";

  boot.kernelPackages = pkgs.linuxPackages_rpi4;
  hardware = {
    deviceTree = {
      enable = true;
      # filter = "*rpi-4-*.dtb";
    };
    raspberry-pi."4" = {
      fkms-3d.enable = true;
      apply-overlays-dtmerge.enable = true;
    };
  };

  services = {
    openssh = {enable = true;};
    xserver = {enable = true;};
  };

  environment = {
    systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
    ];
  };

  system.stateVersion = "23.05";
}
