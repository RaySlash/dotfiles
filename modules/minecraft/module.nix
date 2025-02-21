{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.nix;
  fabandfun-modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/RaySlash/fabandfun-modpack/raw/master/pack.toml";
    packHash = "sha256-s/EPgn8BwJKrfWWEvGaAnYAs/CbbylyvIMR3dDd5844=";
  };
in {
  options.custom.minecraft-servers = {enable = mkEnableOption "minecraft-servers";};

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = true;
      eula = true;
      openFirewall = true;

      servers = {
        fabandfun = {
          enable = true;
          jvmOpts = "-Xms2G -Xmx12G";
          package = pkgs.fabricServers.fabric-1_21_1;
          symlinks = {
            "mods" = "${fabandfun-modpack}/mods";
          };
        };
      };
    };
  };
}
