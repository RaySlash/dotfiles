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
            success_symbol = mkDefault "[ ➜](bold green)";
            error_symbol = mkDefault "[ ➜](bold red)";
          };
        };
      };

      # zellij = {
      #   enable = mkDefault true;
      #   settings = mkDefault {
      #     default_shell = "${pkgs.nushell}/bin/nu";
      #     ui.pane.rounded_corners = true;
      #     show_release_notes = false;
      #     show_startup_tips = false;
      #     keybinds = {
      #       normal = {
      #         unbind = [
      #           "Ctrl q"
      #           "Ctrl s"
      #         ];
      #       };
      #     };
      #   };
      # };
      carapace = {
        enable = mkDefault true;
        enableNushellIntegration = mkDefault true;
      };
      nushell = {
        enable = mkDefault true;
        settings = mkDefault {
          edit_mode = "vi";
          show_banner = false;
        };
        # Load caraspace in nushell
        # Load zellij and auto-attach
        extraConfig = mkDefault ''
          let carapace_completer = {|spans|
            carapace $spans.0 nushell ...$spans | from json
          }
        '';
        # def start_zellij [] {
        #   zellij attach -c
        # }
        # start_zellij
        # zellij attach -c
        shellAliases = mkDefault {
          nix-shell = "nix-shell -p nushell --run nu";
        };
      };
    };
  };
}
