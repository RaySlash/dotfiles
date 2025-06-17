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
          show-mode-in-prompt = true;
          vi-cmd-mode-string = ''\1\e[6 q\2'';
          vi-ins-mode-string = ''\1\e[2 q\2'';
          mark-symlinked-directories = true;
          menu-complete-display-prefix = true;
          print-completions-horizontally = true;
          visible-stats = true;
          page-completions = false;
          enable-bracketed-paste = true;
          show-all-if-ambiguous = true;
          colored-completion-prefix = true;
          completion-ignore-case = true;
          completion-map-case = true;
          bell-style = "none";
        };
      };
      bash = {
        enable = mkDefault true;
        completion.enable = mkDefault true;
        enableVteIntegration = mkDefault true;
        bashrcExtra = ''
          shopt -s autocd
                 shopt -s checkwinsize
                 shopt -s histappend
                 shopt -s no_empty_cmd_completion
                 source "$(carapace bash)"
                 vterm_printf(){
                                 if [ -n "$TMUX" ]; then
                            printf "\ePtmux;\e\e]%s\007\e\\" "$1"
                                 elif [ "''${TERM%%-*}" = "screen" ]; then
                            printf "\eP\e]%s\007\e\\" "$1"
                                 else
                            printf "\e]%s\e\\" "$1"
                                 fi
                 }
                 vterm_cmd() {
                                 local vterm_elisp
                                 vterm_elisp=""
                                 while [ $# -gt 0 ]; do
                            vterm_elisp="$vterm_elisp""$(printf '"%s" ' "$(printf "%s" "$1" | sed -e 's|\\|\\\\|g' -e 's|"|\\"|g')")"
                            shift
                                 done
                                 vterm_printf "51;E$vterm_elisp"
                 }
        '';
        shellAliases = {
          ls = "eza --icons";
          ll = "eza --icons -l";
          cd = "z";
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
