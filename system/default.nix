{
  inputs,
  hub,
  ...
}: let
  mkSystem = args:
    hub.lib.mkSystem {
      system = args.system;
      modules =
        [
          ./common.nix
        ]
        ++ (args.modules or []);
    };
in {
  frost = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/frost
    ];
  };
  wsl = mkSystem {
    system = "x86_64-linux";
    modules = [
      inputs.nixos-wsl.nixosModules.default
      ./hosts/wsl
    ];
  };
  rpi-live = mkSystem {
    system = "aarch64-linux";
    modules = [
      (inputs.nixpkgs + "/nixos/modules/installer/sd-card/sd-image-raspberrypi.nix")
      {
        nixpkgs.crossSystem.system = "armv7l-linux";
      }
      ./hosts/live
    ];
  };
  x86_64-live = mkSystem {
    system = "x86_64-linux";
    modules = [
      (inputs.nixpkgs
        + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      (inputs.nixpkgs
        + "/nixos/modules/installer/cd-dvd/channel.nix")
      {
        nixpkgs.crossSystem.system = "x86_64-linux";
      }
      ./hosts/live
    ];
  };
}
