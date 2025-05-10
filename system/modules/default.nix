{inputs, ...}: let
  programs = [
    "emacs"
    "hyprland"
    "nix"
    "zsh"
    "bash"
    "minecraft-servers"
  ];
  profiles = [
    "desktop"
    "themes"
  ];
in
  builtins.listToAttrs (map (name: {
    name = name;
    value = import ./${name};
  }) (profiles ++ programs))
  // {neovim = (import ../../packages/nixcats {inherit inputs;}).nixosModules.default;}
