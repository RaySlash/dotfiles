{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.profiles.desktop;
in {
  options.custom.profiles.desktop = {enable = mkEnableOption "profiles.desktop";};

  config = mkIf cfg.enable {
    programs = {
      nix-ld.enable = mkDefault true;
      nh = {
        enable = mkDefault true;
        clean.enable = mkDefault true;
        clean.extraArgs = mkDefault "--keep-since 4d --keep 3";
        flake = mkDefault "/home/${inputs.self.localConfig.username}/dotfiles";
      };
    };

    system.autoUpgrade = {
      enable = mkDefault true;
      flake = mkDefault "/home/${inputs.self.localConfig.username}/dotfiles";
      flags = mkDefault ["--update-input" "nixpkgs" "--commit-lock-file"];
    };
  };
}
