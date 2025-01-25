{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
in {
  mkNixos = args: let
    inherit (builtins) attrNames attrValues elem;
    moduleSet = import ../modules {inherit inputs;};
  in
    lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules =
        args.modules
        or []
        ++ [
          ../systems/common/os.nix
          inputs.home-manager.nixosModules.home-manager
	  inputs.nixos-wsl.nixosModules.default
          {
            config.nixpkgs = {
              overlays = [inputs.self.overlays.default 
              inputs.nurpkgs.overlays.default 
              inputs.emacs-overlay.overlays.default];
              config = {allowUnfree = true;};
            };
          }
        ]
        ++ (
          if (elem "home" (attrNames args))
          then [
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = {inherit inputs;};
                users.smj = {
                  pkgs,
                  config,
                  ...
                }:
                  lib.recursiveUpdate
                  (import args.home {inherit inputs pkgs config;})
                  (import ../systems/common/hm.nix {inherit inputs pkgs config;});

                sharedModules =
                  [inputs.nix-index-database.hmModules.nix-index]
                  ++ attrValues moduleSet.homeModules;
              };
            }
          ]
          else []
        )
        ++ attrValues moduleSet.osModules;
    };
}
