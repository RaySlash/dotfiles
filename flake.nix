{
  description = "Personal Flake NixOS config - RaySlash";

  outputs = {flake-parts, ...} @ inputs: let
    unstable-overlay = final: _prev: {
      unstable = import inputs.nixpkgs-unstable {
        system = final.system;
        config.allowUnfree = true;
      };
    };
    packages-overlay = final: _prev: {
      custom = import ./packages final.pkgs;
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
          overlays = [unstable-overlay packages-overlay];
        };
      };

      flake = {...}: {
        overlays = {
          default = final: prev: (inputs.self.overlays.unstable final prev) // (inputs.self.overlays.custom-pkgs final prev);
          unstable = unstable-overlay;
          custom-pkgs = packages-overlay;
        };

        nixosConfigurations = import ./systems {inherit inputs;};
      };
    };

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-24.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";
    nurpkgs = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL/main";
    home-manager = {
      url = "github:nix-community/home-manager/release-24.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Add-ons
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
      inputs.nixpkgs-lib.follows = "nixpkgs";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
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
      inputs.nixpkgs.follows = "nixpkgs-unstable";
    };
  };
}
