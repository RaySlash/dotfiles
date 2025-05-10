{inputs, ...}: let
  profiles = [
    "themes"
  ];
  programs = [
    "emacs"
    "firefox"
    "hyprland"
    "dunst"
    "hypridle"
    "hyprlock"
    "eww"
    "bash"
    "fuzzel"
    "kitty"
    "nushell"
    "wezterm"
  ];
in
  builtins.listToAttrs (map (name: {
    name = name;
    value = import ./${name};
  }) (profiles ++ programs))
  // {neovim = (import ../../packages/nixcats {inherit inputs;}).homeModules.default;}
