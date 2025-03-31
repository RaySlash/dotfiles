{
  inputs,
  lib,
  ...
}: let
  mkSystem = args:
    lib.nixosSystem {
      pkgs = import inputs.nixpkgs {
        config.allowUnfree = true;
        system = args.system;
        overlay = [
          inputs.self.overlays.default
          inputs.nix-minecraft.overlay
        ];
      };
      specialArgs = {
        inherit inputs lib;
        inherit (inputs.self) localConfig;
      };
      modules =
        [
          ./common.nix
          inputs.nix-minecraft.nixosModules.minecraft-servers
        ]
        ++ args.modules
        ++ (builtins.attrValues (import ./modules {inherit inputs;}).nixosModules);
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
        nixpkgs.config.allowUnsupportedSystem = true;
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
