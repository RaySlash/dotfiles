{
  description = "Rust app";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];
      systems = inputs.nixpkgs.lib.systems.flakeExposed;
      perSystem = {
        system,
        pkgs,
        ...
      }: let
        rust-toolchain = inputs.fenix.packages.${system}.stable.toolchain;

        libs = with pkgs; [
          pkg-config
          openssl
        ];

        deps = with pkgs; [
        ];
      in {
        packages.default =
          (pkgs.makeRustPlatform {
            cargo = rust-toolchain;
            rustc = rust-toolchain;
          })
          .buildRustPackage {
            pname = "rust-app";
            version = "0.1.0";
            src = ./.;
            cargoLock.lockFile = ./Cargo.lock;

            buildInputs = libs ++ deps;
            nativeBuildInputs = deps;
          };
        devShells.default = pkgs.mkShell {
        shellHook = ''
          export LD_LIBRARY_PATH="${pkgs.makeLibraryPath libs}"
        '';
          packages =
            [
              rust-toolchain
            ]
            ++ deps;
        };
      };
    };
}
