{
  inputs,
  lib,
  ...
}: let
  username = inputs.self.localConfig.username;
  mkHome = args: let
    mkPkgs = import inputs.nixpkgs {
      config.allowUnfree = true;
      system = args.system;
      overlays = [
        inputs.self.overlays.default
        inputs.nurpkgs.overlays.default
        inputs.emacs-overlay.overlays.default
        inputs.neovim-nightly-overlay.overlays.default
      ];
    };
  in
    inputs.home-manager.lib.homeManagerConfiguration {
      pkgs = mkPkgs;
      extraSpecialArgs = {
        inherit inputs;
        inherit (inputs.self) localConfig;
        # customPkgs = pkgs; # Renamed for clarity
      };
      modules =
        [
          ./common.nix
          inputs.nix-index-database.hmModules.nix-index
        ]
        ++ args.modules
        ++ (builtins.attrValues (import ./modules {inherit inputs;}).homeManagerModules);
    };
in {
  "${username}@frost" = mkHome {
    system = "x86_64-linux";
    modules = [
      ./hosts/frost
    ];
  };
  "${username}@wsl" = mkHome {
    system = "x86_64-linux";
    modules = [
      ./hosts/wsl
    ];
  };
}
