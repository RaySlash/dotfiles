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
      readline = {
	enable = true;
	variables = {
          editing-mode = "vi";
	  vi-cmd-mode-string = ''\001\e[38;5;111m\002 \001\e[0m\002'';
	  vi-ins-mode-string = ''\001\e[38;5;108m\002 \001\e[0m\002'';
          mark-symlinked-directories = true;
          menu-complete-display-prefix = true;
	  print-completions-horizontally = true;
          show-mode-in-prompt = true;
	  show-all-if-ambiguous = true;
          completion-ignore-case = true;
	  colored-completion-prefix = true;
	  completion-map-case = true;
          colored-stats = true;
          bell-style = "none";
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
	  mkcd = ''
	    mkcd() {
              if [ $# -ne 1 ]; then
                echo "Error: Specify exactly one directory name."
                return 1
              fi
              mkdir -p "$1" && cd "$1" || return 1
	    }
	  '';
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
