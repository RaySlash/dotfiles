{
  inputs,
  ...
}:
let
  mkSystem =
    args:
    inputs.nixpkgs.lib.nixosSystem {
      pkgs = import (args.nixpkgs or inputs.nixpkgs) {
        config.allowUnfree = true;
        config.allowUnsupportedSystem = true;
        system = args.system;
        overlays = builtins.attrValues inputs.self.overlays ++ args.overlays or [ ];
      };
      specialArgs = {
        inherit inputs;
      };
      modules = builtins.attrValues inputs.self.nixosModules or [ ] ++ args.modules or [ ];
    };
in
{
  frost = mkSystem {
    system = "x86_64-linux";
    modules = [
      ./hosts/frost
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
      (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/installation-cd-minimal.nix")
      (inputs.nixpkgs + "/nixos/modules/installer/cd-dvd/channel.nix")
      {
        nixpkgs.crossSystem.system = "x86_64-linux";
      }
      ./hosts/live
    ];
  };
}
