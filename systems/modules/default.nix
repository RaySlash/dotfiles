{ inputs, ... }:
let
  programs = [
    # "emacs"
    # "hyprland"
    # "nix"
    "zsh"
    "niri"
    # "bash"
    # "minecraft-servers"
  ];
  profiles = [
    # "desktop"
    # "themes"
  ];
in
builtins.listToAttrs (
  map (name: {
    name = name;
    value = import ./${name};
  }) (profiles ++ programs)
)
