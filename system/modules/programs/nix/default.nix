{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.nix;
in {
  options.custom.programs.nix = {enable = mkEnableOption "programs.nix";};

  config = mkIf cfg.enable {
    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = mkDefault "nix-command flakes";
        flake-registry = mkDefault "";
        nix-path = mkDefault config.nix.nixPath;
        auto-optimise-store = mkDefault true;
        substituters = [
          "https://nix-community.cachix.org"
          "https://cache.nixos.org/"
        ];
        trusted-public-keys = [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
      };
      channel.enable = mkDefault false;
      registry = mkDefault (lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs);
      nixPath = mkDefault (lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs);
    };
  };
}
