{
  description = "Description for the project";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    flake-parts.url = "github:hercules-ci/flake-parts";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {pkgs, ...}: let
        libs = with pkgs; [];
        deps =
          (with pkgs; [
            eslint
            nodejs
            prettierd
            typescript
            typescript-language-server
          ])
          ++ (with pkgs.nodePackages; [
            postcss
          ]);
      in {
        devShells.default = pkgs.mkShell {
          shellHook = ''
            export LD_LIBRARY_PATH="$LD_LIBRARY_PATH:${pkgs.lib.makeLibraryPath libs}"
          '';
          packages = libs ++ deps;
        };
      };
    };
}
