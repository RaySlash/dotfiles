{
  config,
  lib,
  pkgs,
  inputs,
  ...
}: let
  inherit (lib) mkEnableOption mkIf mkDefault mkOverride;
  cfg = config.custom.hyprland-addons;
in {
  options.custom.hyprland-addons = {
    enable = mkEnableOption "hyprland-addons";
  };

  config = mkIf cfg.enable {
    wayland.windowManager.hyprland = {
      enable = mkDefault true;
      extraConfig = mkDefault (builtins.readFile ./hyprland.conf);
    };

    services = {
      cliphist.enable = mkDefault true;
      dunst = {
        enable = mkDefault true;
        settings = {
          global = {
            width = mkDefault 300;
            height = mkDefault 300;
            offset = mkDefault "30x50";
            origin = mkDefault "top-right";
            transparency = mkDefault 10;
            frame_color = mkDefault "#1D1C19";
            font = mkDefault "AtkinsonHyperlegible";
          };

          urgency_normal = {
            background = mkDefault "#0d0c0c";
            foreground = mkDefault "#c5c9c5";
            timeout = mkDefault 10;
          };
        };
        iconTheme = {
          name = mkDefault "Papirus-Dark";
          package = mkDefault pkgs.papirus-icon-theme;
        };
      };
      kdeconnect = {
        enable = mkDefault true;
        indicator = mkDefault true;
      };
      udiskie = {
        enable = mkDefault true;
        notify = mkDefault true;
        automount = mkDefault true;
        tray = mkDefault "auto";
      };
      hypridle = {
        enable = mkDefault true;
        settings = {
          general = {
            after_sleep_cmd = mkDefault "hyprctl dispatch dpms on";
            ignore_dbus_inhibit = mkDefault false;
            lock_cmd = mkDefault "hyprlock";
          };

          listener = mkDefault [
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
      wlogout = {
        enable = mkDefault true;
      };
      fuzzel = {
        enable = mkDefault true;
        settings = {
          main = {
            font = mkDefault "AtkinsonHyperlegible:size=14";
            dpi-aware = mkDefault false;
            use-bold = mkDefault true;
            icons-enabled = mkDefault true;
            icon-theme = mkDefault "Papirus-Dark";
            terminal = mkDefault "kitty -1";
            x-margin = mkDefault 20;
            y-margin = mkDefault 20;
            horizontal-pad = mkDefault 30;
            vertical-pad = mkDefault 20;
            tabs = mkDefault 4;
            inner-pad = mkDefault 50;
            line-height = mkDefault 30;
          };
          colors = {
            background = mkDefault "000000ee";
            text = mkDefault "f9f5d7ff";
            match = mkDefault "563A9Cff";
            selection = mkDefault "433D8Bff";
            selection-text = mkDefault "FFE1FFff";
            selection-match = mkDefault "8B5DFFff";
            border = mkDefault "FFE1FFee";
          };
          border = {
            width = mkDefault 2;
            radius = mkDefault 15;
          };
        };
      };
      hyprlock = {
        enable = mkDefault true;
        settings = mkDefault {
          general = {
            disable_loading_bar = mkDefault true;
            grace = mkDefault 300;
            hide_cursor = mkDefault true;
            no_fade_in = mkDefault false;
          };

          background = mkDefault [
            {
              path = "screenshot";
              blur_passes = 3;
              blur_size = 8;
            }
          ];

          input-field = mkDefault [
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
        enable = mkDefault true;
        configDir = mkDefault ./eww;
      };
      fzf = {
        enable = mkDefault true;
        enableZshIntegration = mkDefault true;
      };
    };

    home = {
      packages = with pkgs; [
        swww
        hyprpolkitagent
        wl-clipboard
        wlr-randr
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
