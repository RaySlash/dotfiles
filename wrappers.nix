{ inputs, ... }:
let
  pkgs = import inputs.nixpkgs {
    config.allowUnfree = true;
    system = "x86_64-linux";
    overlays = builtins.attrValues inputs.self.overlays or [ ];
  };
  wrapped-packages = [
    "zsh"
    "git"
    "emacs"
    "neovim"
    "foot"
    "fuzzel"
    "yazi"
    "niri"
    "swaylock"
    "swayidle"
    "waybar"
  ];
in
builtins.listToAttrs (
  map (name: {
    name = name;
    value = (inputs.wrappers.lib.evalModule ./packages/${name}.nix).config.wrap {
      inherit pkgs;
    };
  }) wrapped-packages
)
