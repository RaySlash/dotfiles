{inputs, ...}: let
  inherit (import ../utils/lib.nix {inherit inputs;}) mkNixos;
in {
  frost = mkNixos {
    modules = [./frost/configuration.nix];
    home = ./frost/home;
  };
  wsl = mkNixos {
    modules = [./wsl/configuration.nix];
    home = ./wsl/home;
  };
  # rpi = mkNixos {
  #   modules = [./rpi/configuration.nix];
  #   home = ./rpi/home;
  # };
  # dell = mkNixos {
  #   modules = [./dell/configuration.nix];
  #   home = ./dell/home;
  # };
  rpi-live = mkNixos {
    modules = [
      (inputs.nixpkgs + "/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix")
      {
        nixpkgs.crossSystem.system = "armv7l-linux";
        nixpkgs.system = "aarch64-linux";
        nixpkgs.config.allowUnsupportedSystem = true;
      }
      ./live/configuration.nix
    ];
  };
  x86_64-live = mkNixos {
    modules = [
      (inputs.nixpkgs
        + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      (inputs.nixpkgs
        + "/nixos/modules/installer/cd-dvd/channel.nix")
      {
        nixpkgs.crossSystem = {system = "x86_64-linux";};
        nixpkgs.system = "x86_64-linux";
      }
      ./live/configuration.nix
    ];
  };
}
