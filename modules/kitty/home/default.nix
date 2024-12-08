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
      themeFile = "3024_Night";
      shellIntegration.enableZshIntegration = true;

      font = {
        name = "IosevkaTerm Nerd Font";
        package = pkgs.nerdfonts.override {fonts = ["IosevkaTerm"];};
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
        linux_display_server = "wayland";
      };

      keybindings = {
        "ctrl+c" = "copy_and_clear_or_interrupt";
        "ctrl+v" = "paste";
      };
    };
  };
}
