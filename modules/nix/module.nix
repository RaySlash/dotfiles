{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.nix;
in {
  options.custom.nix = {enable = mkEnableOption "nix";};

  config = mkIf cfg.enable {
    nix = let
      flakeInputs = lib.filterAttrs (_: lib.isType "flake") inputs;
    in {
      settings = {
        experimental-features = mkDefault "nix-command flakes";
        flake-registry = mkDefault "";
        nix-path = mkDefault config.nix.nixPath;
        auto-optimise-store = mkDefault true;
        substituters = mkDefault ["https://nix-community.cachix.org"];
        trusted-public-keys = mkDefault [
          "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs= mkDefault"
        ];
      };
      channel.enable = mkDefault false;
      registry = mkDefault (lib.mapAttrs (_: flake: {inherit flake;}) flakeInputs);
      nixPath = mkDefault (lib.mapAttrsToList (n: _: "${n}=flake:${n}") flakeInputs);
    };

    programs = {
      nix-ld.enable = mkDefault true;
      nh = {
        enable = mkDefault true;
        clean.enable = mkDefault true;
        clean.extraArgs = mkDefault "--keep-since 4d --keep 3";
        flake = mkDefault "/home/smj/dotfiles";
      };
      direnv = {
        enable = mkDefault true;
        nix-direnv.enable = mkDefault true;
      };
    };

    system.autoUpgrade = {
      enable = mkDefault true;
      flake = mkDefault "/home/smj/dotfiles";
      flags = mkDefault ["--update-input" "nixpkgs" "--commit-lock-file"];
    };
  };
}
