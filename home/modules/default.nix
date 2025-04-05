{inputs, ...}: let
  profiles = {
    development = import ./profiles/development;
    themes = import ./profiles/themes;
  };
  programs = let
    # Import nix modules and pass inputs
    pimport = path: (import path {inherit inputs;});
  in {
    emacs = import ./programs/emacs;
    firefox = import ./programs/firefox;
    hyprland = import ./programs/hyprland;
    dunst = import ./programs/dunst;
    hypridle = import ./programs/hypridle;
    hyprlock = import ./programs/hyprlock;
    eww = import ./programs/eww;
    fuzzel = import ./programs/fuzzel;
    kitty = import ./programs/kitty;
    neovim = (pimport ../../packages/nixcats).homeModules.default;
    wezterm = import ./programs/wezterm;
  };
in
  profiles // programs
