{inputs, ...}: let
  inherit (inputs.nixpkgs.lib) foldl' attrNames elem;
  ## The functions in the files depend only on inputs and few outputs
  ## inputs are used to derive nixpkgs and home-manager
  ## while, outputs are used to fetch commonConfigurations and hub
  # mkSpecialArgs -> Attrset
  # The attribute set values are passed to all modules called by lib.nixosSystem and
  # home-manager.lib.homeManagerConfiguration. BY default, we pass inputs and hub
  mkSpecialArgs = {
    inherit inputs;
    inherit (inputs.self) hub;
  };

  # mkPkgs : system : Maybe nixpkgs : Maybe overlays -> (Instance of nixpkgs)
  # Generate an instance of nixpkgs with overlays applied.
  # All are imported to be reused in home Configuration and nixos Configuration.
  mkPkgs = args:
    import (args.nixpkgs or inputs.nixpkgs) {
      config.allowUnfree = true;
      config.allowUnsupportedSystem = true;
      system = args.system;
      overlays =
        builtins.attrValues inputs.self.overlays
        ++ args.overlays or [];
    };

  # mkHome: system : Maybe modules -> (Home Configuration)
  # Create a home configuration with default and modules.
  # All modules under `outputs.homeModules` are imported to configuration.
  mkHome = args:
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs {
        system = args.system;
      };
      extraSpecialArgs = mkSpecialArgs;
      modules =
        builtins.attrValues inputs.self.homeModules or []
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
        builtins.attrValues inputs.self.nixosModules or []
        ++ args.modules or [];
    };

  # Make the derivation buildable by all available platforms in nixpkgs
  /**
  `flake-utils.lib.eachSystem` but without the flake input

  Builds a map from `<attr> = value` to `<attr>.<system> = value` for each system

  ## Arguments

  - `systems` (`listOf strings`)

  - `f` (`functionTo` `AttrSet`)

  ---
  */
  forEachSystem = let
    eachSystem = systems: f: let
      # get function result and insert system variable
      op = attrs: system: let
        ret = f system;
        op = attrs: key:
          attrs
          // {
            ${key} =
              (attrs.${key} or {})
              // {${system} = ret.${key};};
          };
      in
        foldl' op attrs (attrNames ret);
      # Merge together the outputs for all systems.
    in
      foldl' op {} (systems
        ++ (
          if builtins ? currentSystem && ! elem builtins.currentSystem systems
          # add the current system if --impure is used
          then [builtins.currentSystem]
          else []
        ));
  in
    eachSystem inputs.nixpkgs.lib.platforms.all;
in {
  inherit
    mkPkgs
    mkHome
    mkSystem
    forEachSystem
    ;
}
