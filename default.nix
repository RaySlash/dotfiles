{inputs, ...}: let
  lib = inputs.nixpkgs.lib;
in
  (inputs.flake-parts.lib.mkFlake {inherit inputs;}) {
    systems = [
      "x86_64-linux"
      "x86_64-darwin"
      "aarch64-linux"
      "aarch64-darwin"
      # "armv6l-linux"
      # "armv7l-linux"
      # "i686-linux"
    ];

    imports = [
      inputs.flake-parts.flakeModules.flakeModules
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

    flake = rec {
      overlays = {
        # stable-pkgs: This overlay adds the stable branch of nixpkgs under
        # `pkgs.stablePackages` to access stable branch.
        # Example: `home.packages = [pkgs.stablePackages.neovim];`
        stable-pkgs = final: _prev: {
          stablePackages = import inputs.nixpkgs-stable {
            system = final.system;
            config.allowUnfree = true;
          };
        };
        # custom-pkgs: This overlay adds all locally defined packages
        # under `customPackages`.
        # Example: `home.packages = [pkgs.customPackages.nvimcat];`
        custom-pkgs = final: _prev: {
          customPackages = import ./packages final.pkgs;
        };
        # Add home-manager CLI from inputs to `pkgs.home-manager-master`
        home-manager = final: _prev: {
          home-manager-master =
            inputs.home-manager.packages.${final.system}.home-manager;
        };
        nurpkgs = inputs.nurpkgs.overlays.default;
        nix-minecraft = inputs.nix-minecraft.overlay;
        neovim-nightly = inputs.neovim-nightly-overlay.overlays.default;
        emacs = inputs.emacs-overlay.overlays.default;
      };

      templates = import ./templates;
      hub = import ./config.nix {inherit inputs;};
      nixosConfigurations = import ./system {inherit inputs hub;};
      homeConfigurations = import ./home {inherit inputs hub;};
      flakeModules.default = import ./utils/flake-module.nix {inherit inputs lib hub;};
      nixosModules = import ./system/modules {inherit inputs lib hub;};
      homeModules = import ./home/modules {inherit inputs lib hub;};

      images = {
        rpi-sd = inputs.self.nixosConfigurations.rpi-live.config.system.build.sdImage;
        x86_64 = inputs.self.nixosConfigurations.x86_64-live.config.system.build.isoImage;
      };
    };
  }
