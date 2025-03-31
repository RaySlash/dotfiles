{
  config,
  lib,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.programs.wezterm;
in {
  options.custom.programs.wezterm = {enable = mkEnableOption "programs.wezterm";};

  config = mkIf cfg.enable {
    home.file."/home/${inputs.self.localConfig.username}/.config/wezterm/sessionizer.lua".source =
      ./sessionizer.lua;

    programs.wezterm = {
      enable = true;
      # package = inputs.wezterm.packages.x86_64-linux.default;
      enableZshIntegration = true;
      colorSchemes = {
        kanagawa_custom = {
          ansi = [
            "#090618"
            "#c34043"
            "#76946a"
            "#c0a36e"
            "#7e9cd8"
            "#957fb8"
            "#6a9589"
            "#dcd7ba"
          ];
          brights = [
            "#727169"
            "#e82424"
            "#98bb6c"
            "#e6c384"
            "#7fb4ca"
            "#938aa9"
            "#7aa89f"
            "#c8c093"
          ];
          cursor_bg = "#dcd7ba";
          cursor_border = "#dcd7ba";
          cursor_fg = "#1f1f28";
          foreground = "#dcd7ba";
          background = "#000000";
        };
      };
      extraConfig = builtins.readFile ./wezterm.lua;
    };
  };
}
