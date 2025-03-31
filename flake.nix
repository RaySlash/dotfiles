{
  description = "Personal Flake NixOS config - RaySlash";

  outputs = {flake-parts, ...} @ inputs: let
    packages-overlay = final: _prev: {
      custom = import ./packages final.pkgs;
    };
    stable-overlay = final: _prev: {
      stablePkgs = import inputs.nixpkgs-stable {
        system = final.system;
        config.allowUnfree = true;
      };
    };
    lib = inputs.nixpkgs.lib;
  in
    (flake-parts.lib.mkFlake {inherit inputs;}) {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      debug = true; # Enable debug log trace in repl

      imports = [
        inputs.home-manager.flakeModules.default
        # inputs.flake-parts.flakeModules.flakeModules
      ];

      perSystem = {
        system,
        inputs',
        pkgs,
        ...
      }: let
        nixcats = (import ./packages/nixcats {inherit inputs;}).packages.${system};
      in {
        packages = import ./packages {inherit pkgs inputs;} // nixcats;
        formatter = inputs'.nixpkgs.legacyPackages.alejandra;

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.self.overlays.default
            inputs.emacs-overlay.overlays.default
            inputs.neovim-nightly-overlay.overlays.default
          ];
        };
      };

      flake = {
        overlays = {
          default = final: prev: (inputs.self.overlays.custom-pkgs final prev) // (inputs.self.overlays.stable-pkgs final prev);
          stable-pkgs = stable-overlay;
          custom-pkgs = packages-overlay;
        };

        localConfig = import ./config.nix;
        nixosConfigurations = import ./system {inherit inputs lib;};
        homeConfigurations = import ./home {inherit inputs lib;};
        nixosModules = (import ./system/modules {inherit inputs lib;}).nixosModules;
        homeModules = (import ./home/modules {inherit inputs lib;}).homeManagerModules;

        images = {
          rpi-sd = inputs.self.nixosConfigurations.rpi-live.config.system.build.sdImage;
          x86_64 = inputs.self.nixosConfigurations.x86_64-live.config.system.build.isoImage;
        };
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs?ref=nixos-24.11";
    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Add-ons
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    # wezterm.url = "github:wez/wezterm?dir=nix";
    meteorbom = {
      url = "git+ssh://git@github.com/rayslash/meteorbom/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
    };
    kanagawa-yazi = {
      url = "github:marcosvnmelo/kanagawa-dragon.yazi";
      flake = false;
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
  };
}
