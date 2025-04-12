{inputs, ...}: let
  # mkSpecialArgs : Attrset
  # The attribute set values are passed to all modules called by lib.nixosSystem and
  # home-manager.lib.homeManagerConfiguration. BY default, we pass inputs and localConfig
  mkSpecialArgs = {
    inherit inputs;
    inherit (inputs.self) localConfig;
  };

  # mkPkgs : system -> Maybe nixpkgs -> Maybe overlays -> (Instance of nixpkgs)
  # Generate an instance of nixpkgs with overlays applied.
  # All are imported to be reused in home Configuration and nixos Configuration.
  mkPkgs = args:
    import (args.nixpkgs or inputs.nixpkgs) {
      config.allowUnfree = true;
      system = args.system;
      overlays =
        builtins.attrValues inputs.self.overlays
        ++ args.overlays or [];
    };

  # mkHome: system -> Maybe modules -> (Home Configuration)
  # Create a home configuration with default and modules.
  # All modules under `outputs.homeModules` are imported to configuration.
  mkHome = args:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs {
        system = args.system;
      };
      extraSpecialArgs = mkSpecialArgs;
      modules =
        [./home/common.nix]
        ++ builtins.attrValues inputs.self.homeModules or []
        ++ args.modules or [];
    };

  # mkSystem: system -> Maybe modules -> (NixOS Configuration)
  # Create a nixos configuration with default and modules.
  # All modules under `outputs.nixosModules` are imported to configuration.
  mkSystem = args:
    inputs.nixpkgs.lib.nixosSystem {
      pkgs = mkPkgs {
        system = args.system;
      };
      specialArgs = mkSpecialArgs;
      modules =
        [./system/common.nix]
        ++ builtins.attrValues inputs.self.nixosModules or []
        ++ args.modules or [];
    };
in {
  inherit
    mkPkgs
    mkHome
    mkSystem
    ;
}
