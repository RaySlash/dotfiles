{
  description = "ELM Website";

  inputs = {
    flake-parts.url = "github:hercules-ci/flake-parts";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs @ {flake-parts, ...}:
    flake-parts.lib.mkFlake {inherit inputs;} {
      imports = [];
      systems = ["x86_64-linux" "aarch64-linux" "aarch64-darwin" "x86_64-darwin"];
      perSystem = {pkgs, ...}: let
        deps = with pkgs; [
          lessc
          pnpm
          nodejs
          elmPackages.elm
        ];
      in {
        devShells = {
          default = {
            packages = deps;
          };
        };
      };
    };
}
