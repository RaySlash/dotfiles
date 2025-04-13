{inputs, ...}: let
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
  (inputs.flake-parts.lib.mkFlake {inherit inputs;}) {
    systems = lib.platforms.linux;
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
      # formatter = inputs'.nixpkgs.legacyPackages.alejandra;

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
      templates = import ./templates;
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
  }
