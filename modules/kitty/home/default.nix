{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.kitty;
in {
  options.custom.kitty = {enable = mkEnableOption "kitty";};

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = true;
      themeFile = "kanagawa_dragon";
      shellIntegration.enableZshIntegration = true;

      font = {
        name = "IosevkaTerm Nerd Font";
        package = pkgs.nerd-fonts.iosevka-term;
        size = 14;
      };

      settings = {
        editor = "nvim";
        shell = "zsh";
        dynamic_background_opacity = true;
        background_opacity = 0.8;
        background_blur = 32;
        hide_window_decorations = true;
        confirm_os_window_close = 0;
        enable_audio_bell = false;
        allow_remote_control = true;
        linux_display_server = "wayland";
      };

      keybindings = {
        "ctrl+c" = "copy_and_clear_or_interrupt";
        "ctrl+v" = "paste";
        "ctrl+shift+a" = "new_tab_with_cwd";
      };
    };
  };
}
