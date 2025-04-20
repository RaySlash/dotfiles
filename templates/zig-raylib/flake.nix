{
  description = "Description for the project";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    zig.url = "github:bandithedoge/zig-overlay";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {
        pkgs,
        system,
        ...
      }: let
        libs = with pkgs;
          [
            pkg-config
            coreutils
            bashInteractive
            stdenv.cc.libc_bin
            openlibm
            wayland-scanner
            egl-wayland
            eglexternalplatform
            libGL
            libxkbcommon
          ]
          ++ (with pkgs.xorg; [
            libX11
            libXcursor
            libXext
            libXfixes
            libXi
            libXinerama
            libXrandr
            libXrender
          ]);
        deps = with pkgs; [
          gcc
          zigpkgs.default
          zigpkgs.zls-latest
          wayland
          wayland-protocols
        ];
      in {
        _module.args.pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.zig.overlays.default
          ];
        };
        devShells.default = pkgs.mkShell {
          shellHook = ''
            export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath libs}
          '';
          packages = deps ++ libs;
        };
      };
    };
}
