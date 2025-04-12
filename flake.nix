{
  description = "Personal Flake NixOS config - RaySlash";

  outputs = {flake-parts, ...} @ inputs: let
    lib = inputs.nixpkgs.lib;
    packages-overlay = final: _prev: {
      custom = import ./packages final.pkgs;
    };
    stable-overlay = final: _prev: {
      stablePkgs = inputs.self.utils.mkPkgs {
        nixpkgs = inputs.nixpkgs-stable;
        system = final.system;
      };
    };
  in
    (flake-parts.lib.mkFlake {inherit inputs;}) {
      systems = lib.platforms.all;
      # debug = true; # Enable debug options (allSystems) in repl

      imports = [
        inputs.home-manager.flakeModules.default
      ];

      perSystem = {
        system,
        inputs',
        pkgs,
        ...
      }: {
        packages =
          import ./packages {inherit pkgs inputs;};
        formatter = inputs'.nixpkgs.legacyPackages.alejandra;

        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = builtins.attrValues inputs.self.overlays;
        };
      };

      flake = {
        overlays = {
          default = final: prev: (inputs.self.overlays.custom-pkgs final prev) // (inputs.self.overlays.stable-pkgs final prev);
          stable-pkgs = stable-overlay;
          custom-pkgs = packages-overlay;
          nurpkgs = inputs.nurpkgs.overlays.default;
          nix-minecraft = inputs.nix-minecraft.overlay;
          neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;
          emacs = inputs.emacs-overlay.overlays.default;
        };

        localConfig = import ./config.nix;
        utils = import ./utils.nix {inherit inputs;};
        nixosConfigurations = import ./system {inherit inputs lib;};
        homeConfigurations = import ./home {inherit inputs lib;};
        nixosModules = import ./system/modules {inherit inputs lib;};
        homeModules = import ./home/modules {inherit inputs lib;};

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
      url = "github:nix-community/home-manager?ref=master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware";
    nixos-wsl.url = "github:nix-community/NixOS-WSL?ref=main";
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Flake Add-ons
    flake-parts = {
      url = "github:hercules-ci/flake-parts";
    };
    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-index-database = {
      url = "github:Mic92/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Applications
    # wezterm.url = "github:wez/wezterm?dir=nix";
    # base16.url = "github:SenchoPens/base16.nix";
    stylix.url = "github:danth/stylix";
    tt-schemes = {
      url = "github:rayslash/tinted-theme-schemes/kanagawa-dragon";
      flake = false;
    };
    zen-browser = {
      url = "github:0xc000022070/zen-browser-flake";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    meteorbom = {
      url = "git+ssh://git@github.com/rayslash/meteorbom";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-minecraft.url = "github:Infinidoge/nix-minecraft";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";
    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    plugins-lze = {
      url = "github:BirdeeHub/lze";
      flake = false;
    };
    plugins-lzextras = {
      url = "github:BirdeeHub/lzextras";
      flake = false;
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
    };
  };
}
