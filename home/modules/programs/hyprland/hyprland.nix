{
  exec-once = [
    "dbus-update-activation-environment --systemd --all"
    "systemctl --user start hyprpolkitagent"
    "swww-daemon &"
    "eww open bar &"
    "wl-paste --type text --watch cliphist store &"
    "wl-paste --type image --watch cliphist store &"
    "openrgb --startminimized -p smj &"
    "hypridle &"
  ];
  env = [
    "XCURSOR_SIZE,32"
    "WLR_NO_HARDWARE_CURSORS,1"
    "MOZ_ENABLE_WAYLAND,1"
    "GDK_BACKEND=wayland,x11"
    "QT_QPA_PLATFORM,wayland;xcb"
    "SDL_VIDEODRIVER=wayland"
    "CLUTTER_BACKEND=wayland"
    "HYPRCURSOR_THEME,macOS-White"
    "HYPRCURSOR_SIZE,24"
  ];

  monitor = [
    "DP-1, 1920x1080@60, auto, 1"
    "DP-3, 1920x1080@60, auto, 1"
  ];

  input = {
    kb_layout = "us";
    follow_mouse = 1;
    sensitivity = 0;
    accel_profile = "flat";
    touchpad = {
      natural_scroll = false;
    };
  };

  general = {
    gaps_in = 5;
    gaps_out = 10;
    border_size = 2;
    "col.active_border" = "rgba(fb4934aa)";
    "col.inactive_border" = "rgba(000000aa)";
    layout = "master";
  };

  decoration = {
    rounding = 8;
    active_opacity = 1;
    inactive_opacity = 1;
    shadow = {
      enabled = true;
      range = 8;
      render_power = 3;
      color = "rgba(1a1a1aee)";
    };
    blur = {
      enabled = "yes";
      size = 3;
      passes = 3;
      new_optimizations = 1;
    };
  };

  master = {
    new_on_top = true;
  };

  misc = {
    vrr = 1;
    vfr = 1;
  };

  "$mod" = "SUPER";

  bind = [
    "$mod, return, exec, kitty"
    "$mod_SHIFT, Q, killactive,"
    "$mod_SHIFT, M, exit,"
    "$mod_SHIFT, L, exec, wlogout"
    "$mod, D, exec, kitty -1 yazi"
    "$mod, F, togglefloating"
    "$mod_SHIFT, return, exec, fuzzel --show-actions"
    "$mod, V, exec, sh -c 'cliphist list | fuzzel --dmenu | cliphist decode | wl-copy'"
    ", XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+"
    ", XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"
    ", XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
    "$mod, XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05+"
    "$mod, XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SOURCE@ 0.05-"
    "$mod, XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"
    "$mod, P, exec, grim -g '$(slurp)'"
    "$mod, x, togglespecialworkspace, scratch"
    "$mod_SHIFT, x, movetoworkspace, special:scratch"
    "$mod, left, movefocus, l"
    "$mod, right, movefocus, r"
    "$mod, up, movefocus, u"
    "$mod, down, movefocus, d"
    "$mod, 1, workspace, 1"
    "$mod, 2, workspace, 2"
    "$mod, 3, workspace, 3"
    "$mod, 4, workspace, 4"
    "$mod, 5, workspace, 5"
    "$mod, 6, workspace, 6"
    "$mod, 7, workspace, 7"
    "$mod, 8, workspace, 8"
    "$mod, 9, workspace, 9"
    "$mod_SHIFT, 1, movetoworkspace, 1"
    "$mod_SHIFT, 2, movetoworkspace, 2"
    "$mod_SHIFT, 3, movetoworkspace, 3"
    "$mod_SHIFT, 4, movetoworkspace, 4"
    "$mod_SHIFT, 5, movetoworkspace, 5"
    "$mod_SHIFT, 6, movetoworkspace, 6"
    "$mod_SHIFT, 7, movetoworkspace, 7"
    "$mod_SHIFT, 8, movetoworkspace, 8"
    "$mod_SHIFT, 9, movetoworkspace, 9"
    "$mod, mouse_down, workspace, e+1"
    "$mod, mouse_up, workspace, e-1"
    "$mod, N, layoutmsg, cyclenext"
    "$mod, B, layoutmsg, swapwithmaster master"
  ];
  bindm = [
    "$mod, mouse:272, movewindow"
    "$mod, mouse:273, resizewindow"
  ];
  binde = [
    "$mod_SHIFT, h, resizeactive, -30 0"
    "$mod_SHIFT, l, resizeactive, 30 0"
    "$mod_SHIFT, j, resizeactive, 0 30"
    "$mod_SHIFT, k, resizeactive, 0 -30"
  ];
}
