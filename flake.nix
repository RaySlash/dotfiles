{
  description = "Dotfiles (rayslash)";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nix-cachyos-kernel.url = "github:xddxdd/nix-cachyos-kernel/release";
    flake-parts.url = "github:hercules-ci/flake-parts";

    wrappers = {
      url = "github:BirdeeHub/nix-wrapper-modules";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{ flake-parts, ... }:
    let
      lib = inputs.nixpkgs.lib;
    in
    flake-parts.lib.mkFlake { inherit inputs; } {
      imports = [
        inputs.flake-parts.flakeModules.flakeModules
        inputs.wrappers.flakeModules.wrappers
      ];
      systems = inputs.nixpkgs.lib.platforms.all;
      perSystem =
        {
          config,
          self',
          inputs',
          pkgs,
          system,
          ...
        }:
        {
          packages = import ./packages { inherit pkgs inputs; };
          # wrappers = import ./wrappers.nix { inherit pkgs inputs; };
          formatter = inputs'.nixpkgs.legacyPackages.alejandra;

          _module.args.pkgs = import inputs.nixpkgs {
            inherit system;
            config.allowUnfree = true;
            overlays = builtins.attrValues inputs.self.overlays;
          };
        };
      flake = {
        overlays = import ./overlays.nix { inherit inputs; };
        # wrappers = import ./wrappers.nix { inherit inputs; };
        flakeModules.default = import ./flake-module.nix { inherit inputs lib; };
        nixosConfigurations = import ./systems { inherit inputs lib; };
        nixosModules = import ./systems/modules { inherit inputs lib; };
      };
    };
}
