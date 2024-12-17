{inputs, ...}: let
  inherit (import ../utils/builders.nix {inherit inputs;}) mkNixos;
in {
  frost = mkNixos {
    modules = [./frost/configuration.nix];
    home = ./frost/home;
  };
  rpi = mkNixos {
    modules = [./rpi/configuration.nix];
    home = ./rpi/home;
  };
  dell = mkNixos {
    modules = [./dell/configuration.nix];
    home = ./dell/home;
  };
  live = mkNixos {
    modules = [
      (inputs.nixpkgs
        + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      ./iso/configuration.nix
    ];
  };
}
