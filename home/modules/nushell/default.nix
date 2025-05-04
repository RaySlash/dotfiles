{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault mkForce;
  cfg = config.custom.programs.nushell;
in {
  options.custom.programs.nushell = {enable = mkEnableOption "programs.nushell";};

  config = mkIf cfg.enable {
    programs = {
      starship = {
        enable = mkDefault true;
        settings = {
          add_newline = mkDefault true;
          character = {
            success_symbol = mkDefault "[➜](bold green)";
            error_symbol = mkDefault "[➜](bold red)";
          };
        };
      };

      zellij = {
        enable = true;
        settings = {
          default_shell = "${pkgs.nushell}/bin/nu";
          ui.pane.rounded_corners = true;
          show_release_notes = false;
        };
      };
      carapace = {
        enable = true;
        enableNushellIntegration = true;
      };
      nushell = {
        enable = mkDefault true;
        settings = {
          edit_mode = "vi";
          show_banner = false;
        };
        extraConfig = ''
          let carapace_completer = {|spans|
             carapace $spans.0 nushell ...$spans | from json
          }
          zellij attach -c
        '';
        shellAliases = {
          nix-shell = "nix-shell -p nushell --run nu";
        };
      };
    };
  };
}
