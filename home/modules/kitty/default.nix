{
  config,
  lib,
  pkgs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault mkForce;
  cfg = config.custom.programs.kitty;
in {
  options.custom.programs.kitty = {enable = mkEnableOption "programs.kitty";};

  config = mkIf cfg.enable {
    programs.kitty = {
      enable = mkDefault true;
      # themeFile = mkDefault "kanagawa_dragon";
      shellIntegration.enableZshIntegration = mkDefault true;

      # font = {
      #   name = mkDefault "IosevkaTerm Nerd Font";
      #   package = mkDefault pkgs.nerd-fonts.iosevka-term;
      #   size = mkForce 12;
      # };
      #
      settings = {
        editor = mkDefault "nvim";
        shell = mkDefault "zsh";
        dynamic_background_opacity = mkDefault true;
        background = "#000000";
        background_opacity = mkDefault 0.8;
        background_blur = mkDefault 32;
        hide_window_decorations = mkDefault true;
        confirm_os_window_close = mkDefault 0;
        enable_audio_bell = mkDefault false;
        allow_remote_control = mkDefault true;
        linux_display_server = mkDefault "wayland";
      };

      keybindings = {
        "ctrl+c" = mkDefault "copy_and_clear_or_interrupt";
        "ctrl+v" = mkDefault "paste";
        "ctrl+shift+a" = mkDefault "new_tab_with_cwd";
      };
    };
  };
}
