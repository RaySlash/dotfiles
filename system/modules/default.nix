{inputs, ...}: let
  programs = let
    pimport = path: (import path {inherit inputs;});
  in {
    emacs = import ./programs/emacs;
    hyprland = import ./programs/hyprland;
    nix = import ./programs/nix;
    zsh = import ./programs/zsh;
    minecraft-servers = import ./programs/minecraft-servers;
    yazi = import ./programs/yazi;
    neovim = (pimport ../../packages/nixcats).nixosModule;
  };
  profiles = {
    development = import ./profiles/development;
    desktop = import ./profiles/desktop;
    themes = import ./profiles/themes;
  };
  nixosModules = programs // profiles;
in {
  inherit nixosModules;
}
