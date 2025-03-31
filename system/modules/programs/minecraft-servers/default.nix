{
  config,
  lib,
  inputs,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.minecraft-servers;
  fabandfun-modpack = pkgs.fetchPackwizModpack {
    url = "https://github.com/RaySlash/fabandfun-modpack/raw/master/pack.toml";
    packHash = "sha256-s/EPgn8BwJKrfWWEvGaAnYAs/CbbylyvIMR3dDd5844=";
  };
in {
  options.custom.programs.minecraft-servers = {
    enable = mkEnableOption "programs.minecraft-servers";
  };

  config = mkIf cfg.enable {
    services.minecraft-servers = {
      enable = mkDefault true;
      eula = mkDefault true;
      openFirewall = mkDefault true;

      servers = {
        fabandfun = {
          enable = mkDefault false;
          jvmOpts = mkDefault "-Xms2G -Xmx12G";
          package = mkDefault pkgs.fabricServers.fabric-1_21_1;
          symlinks = mkDefault {
            "mods" = "${fabandfun-modpack}/mods";
          };
        };
      };
    };
  };
}
