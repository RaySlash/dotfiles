{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault;
  cfg = config.custom.programs.zsh;
in {
  options.custom.programs.zsh = {enable = mkEnableOption "programs.zsh";};

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = mkDefault true;
        syntaxHighlighting.enable = mkDefault true;
        autosuggestions.enable = mkDefault true;
        zsh-autoenv.enable = mkDefault true;
        enableCompletion = mkDefault true;
        histSize = mkDefault 10000;
        ohMyZsh = {
          enable = mkDefault true;
          theme = mkDefault "intheloop";
        };
        shellAliases = mkDefault {
          ls = "eza --icons";
          ll = "eza --icons -l";
          ffd = "cd $(fd -t d --max-depth 4 . ~/Projects | fzf)";
          gl = "git log";
          gs = "git status";
          gc = "git commit";
          gca = ''git add . && git commit -m "update"'';
          gp = "git push";
          nix-shell = "nix-shell --run zsh";
        };
      };
    };

    environment.shells = [pkgs.zsh];
  };
}
