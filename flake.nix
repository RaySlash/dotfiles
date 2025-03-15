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
  in
    (flake-parts.lib.mkFlake {inherit inputs;}) {
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      debug = true; # Enable debug log trace in repl

      imports = [
        inputs.flake-parts.flakeModules.flakeModules
      ];

      perSystem = {
        system,
        inputs',
        pkgs,
        ...
      }: let
        nvimcat =
          (import ./modules {inherit inputs;}).pkgs.nvimcat.${system};
      in {
        formatter = inputs'.nixpkgs.legacyPackages.alejandra;
        packages = import ./packages/default.nix inputs'.nixpkgs.legacyPackages // nvimcat;

        devShells.default = pkgs.mkShell {
          packages = with pkgs; [
            coreutils
            fd
            ripgrep
          ];
        };

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [packages-overlay stable-overlay];
        };
      };

      flake = {...}: {
        overlays = {
          default = final: prev: (inputs.self.overlays.custom-pkgs final prev) // (inputs.self.overlays.stable-pkgs final prev);
          stable-pkgs = stable-overlay;
          custom-pkgs = packages-overlay;
        };

        nixosConfigurations = import ./systems {inherit inputs;};
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:nixos/nixpkgs/nixos-24.11";
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

    # Flake Add-ons
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    sops-nix.url = "github:Mic92/sops-nix";
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    # wezterm.url = "github:wez/wezterm?dir=nix";
    meteorbom = {
      url = "git+ssh://git@github.com/rayslash/meteorbom?ref=master";
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
