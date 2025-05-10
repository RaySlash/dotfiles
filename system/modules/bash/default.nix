{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.bash;
in {
  options.custom.programs.bash = {enable = mkEnableOption "programs.bash";};

  config = mkIf cfg.enable {
    programs = {
      bash = {
        completion.enable = mkDefault true;
        enableLsColors = mkDefault true;
        shellAliases = {
          ls = "eza --icons";
          ll = "eza --icons -l";
          ffd = "cd $(fd -t d --max-depth 4 . ~/Projects | fzf)";
          gl = "git log";
          gs = "git status";
          gc = "git commit";
          gca = ''git add . && git commit -m "update"'';
          gp = "git push";
          nix-shell = "nix-shell --run bash";
        };
      };
    };

    environment.shells = [pkgs.bash];
  };
}
