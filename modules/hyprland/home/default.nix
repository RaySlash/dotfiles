{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf;
  cfg = config.custom.hyprland-addons;
in {
  options.custom.hyprland-addons = {
    enable = mkEnableOption "hyprland-addons";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      extraConfig = builtins.readFile ./hyprland.conf;
    };

    services = {
      cliphist.enable = true;
      dunst = {
        enable = true;
        settings = {
          global = {
            width = 300;
            height = 300;
            offset = "30x50";
            origin = "top-right";
            transparency = 10;
            frame_color = "#1D1C19";
            font = "AtkinsonHyperlegible";
          };

          urgency_normal = {
            background = "#0d0c0c";
            foreground = "#c5c9c5";
            timeout = 10;
          };
        };
        iconTheme = {
          name = "Papirus-Dark";
          package = pkgs.papirus-icon-theme;
        };
      };
      kdeconnect = {
        enable = true;
        indicator = true;
      };
      udiskie = {
        enable = true;
        notify = true;
        automount = true;
        tray = "auto";
      };
      hypridle = {
        enable = true;
        settings = {
          general = {
            after_sleep_cmd = "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = false;
            lock_cmd = "hyprlock";
          };

          listener = [
            {
              timeout = 900;
              on-timeout = "hyprlock";
            }
            {
              timeout = 1200;
              on-timeout = "hyprctl dispatch dpms off";
              on-resume = "hyprctl dispatch dpms on";
            }
          ];
        };
      };
    };

    programs = {
      fuzzel = {
        enable = true;
        settings = {
          main = {
            font = "AtkinsonHyperlegible:size=14";
            dpi-aware = false;
            use-bold = true;
            icons-enabled = true;
            icon-theme = "Papirus-Dark";
            terminal = "kitty -1";
            x-margin = 20;
            y-margin = 20;
            horizontal-pad = 30;
            vertical-pad = 20;
            tabs = 4;
            inner-pad = 50;
            line-height = 30;
          };
          colors = {
            background = "000000ee";
            text = "f9f5d7ff";
            match = "563A9Cff";
            selection = "433D8Bff";
            selection-text = "FFE1FFff";
            selection-match = "8B5DFFff";
            border = "FFE1FFee";
          };
          border = {
            width = 2;
            radius = 15;
          };
        };
      };
      hyprlock = {
        enable = true;
        settings = {
          general = {
            disable_loading_bar = true;
            grace = 300;
            hide_cursor = true;
            no_fade_in = false;
          };

          background = [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = [
            {
              size = "200, 50";
              position = "0, -80";
              monitor = "";
              dots_center = true;
              fade_on_empty = false;
              font_color = "rgb(202, 211, 245)";
              inner_color = "rgb(91, 96, 120)";
              outer_color = "rgb(24, 25, 38)";
              outline_thickness = 5;
              placeholder_text = "Password...";
              shadow_passes = 2;
            }
          ];
        };
      };
      eww = {
        enable = true;
        configDir = ./eww;
      };
      fzf = {
        enable = true;
        enableZshIntegration = true;
      };
    };

    home = {
      packages = with pkgs; [
        swww
        hyprpolkitagent
        wl-clipboard
        wlr-randr
        wlogout
        wirelesstools
        grim
        slurp
        libva-utils
        fuseiso
        gsettings-desktop-schemas
        pwvucontrol

        inputs.meteorbom.packages.${pkgs.system}.default
        #eww dependencies
        jq
        lm_sensors
        python3
        socat
      ];
    };
  };
}
