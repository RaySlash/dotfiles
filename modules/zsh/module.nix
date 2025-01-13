{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.zsh;
in {
  options.custom.zsh = {enable = mkEnableOption "zsh";};

  config = mkIf cfg.enable {
    programs = {
      zsh = {
        enable = true;
        syntaxHighlighting.enable = true;
        autosuggestions.enable = true;
        zsh-autoenv.enable = true;
        enableCompletion = true;
        histSize = 10000;
        ohMyZsh = {
          enable = true;
          theme = "intheloop";
        };
        shellAliases = {
          ls = "eza --icons";
          ll = "eza --icons -l";
          ffd = "cd $(fd -t d --max-depth 4 . ~/Projects | fzf)";
          gl = "git log";
          gs = "git status";
          gc = "git commit";
          gca = ''git add . && git commit -m "update"'';
          gp = "git push";
          nix-boot = "nh os boot";
          nix-switch = "nh os switch";
          nix-shell = "nix-shell --run zsh";
        };
      };
    };

    environment.shells = [pkgs.zsh];
  };
}
