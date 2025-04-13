{
  description = "C with raylib";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {pkgs, ...}: let
        libs = with pkgs; [
          pkg-config
          coreutils
          bashInteractive
          stdenv.cc.libc_bin
          openlibm
          wayland-scanner
          egl-wayland
        ];
        deps = with pkgs; [
          gcc
          raylib
        ];
      in {
        packages.default = pkgs.stdenv.mkDerivation {
          pname = "c-raylib";
          version = "0.0.1";

          src = ./src;

          buildInputs = deps;
          nativeBuildInputs = libs;

          installPhase = ''
            mkdir -p $out/bin
            gcc main.c -o $out/bin/c-raylib -lraylib -lm -Wall -Werror -pedantic
            chmod +x $out/bin/c-raylib
          '';
        };

        packages.release = pkgs.stdenv.mkDerivation {
          pname = "c-raylib";
          version = "0.0.1";

          src = ./src;

          buildInputs = deps;
          nativeBuildInputs = libs;

          installPhase = ''
            mkdir -p $out/bin
            gcc main.c -o $out/bin/c-raylib -lraylib -lm -Wall -Werror -pedantic -O3
            chmod +x $out/bin/c-raylib
          '';
        };

        devShells.default = pkgs.mkShell {
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath libs}"
            export CFLAGS="-I${pkgs.raylib}/include $CFLAGS"

            echo "Alternatively, use the following to build:"
            echo "gcc src/main.c -lraylib -lm"
          '';
          packages = deps;
        };
      };
    };
}
