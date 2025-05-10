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
      carapace = {
        enable = mkDefault true;
      };
      direnv = {
        enable = mkDefault true;
        nix-direnv.enable = mkDefault true;
      };
      eza = {
        enable = mkDefault true;
        colors = mkDefault "auto";
      };
      fzf = {
        enable = mkDefault true;
      };
      nix-index = {
        enable = mkDefault true;
      };
      yazi = {
        enable = mkDefault true;
      };
      zoxide = {
        enable = mkDefault true;
      };
      starship = {
        enable = mkDefault true;
        settings = {
          add_newline = true;
        };
      };
      bash = {
        enable = mkDefault true;
        enableCompletion = mkDefault true;
        enableVteIntegration = mkDefault true;
        bashrcExtra = ''
          set -o vi
          export CARAPACE_BRIDGES='bash,zsh'
          source <(carapace _carapace bash)
        '';
        shellAliases = {
          ls = "eza --icons";
          ll = "eza --icons -l";
          ffd = "cd $(fd -t d --max-depth 4 . ~/Projects | fzf)";
          gl = "git log";
          gs = "git status";
          gc = "git commit";
          gca = ''git add . && git commit -m "dev: fast update"'';
          gp = "git push";
        };
      };
    };
    home.shell.enableBashIntegration = mkDefault true;
  };
}
