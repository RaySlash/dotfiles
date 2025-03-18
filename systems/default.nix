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
  live = mkNixos {
    modules = [
      (inputs.nixpkgs
        + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      (inputs.nixpkgs
        + "/nixos/modules/installer/cd-dvd/channel.nix")
      ./iso/configuration.nix
    ];
  };
}
