{
  pkgs,
  inputs,
  ...
}: let
  packages = [
    # "meteorbom"
    # "wezterm"
    # "neovide"
    # "md2pdf"
    # "yofi"
    # dioxus-cli
    # hyprland-py
    # typstudio
    # vscode-css-languageservice
  ];
  wrapped-packages = [
    "zsh"
    "git"
  ];
in
# Map normal nix packages
  builtins.listToAttrs (map (name: {
      name = name;
      value = pkgs.callPackage ./${name} {};
    })
    packages)
# Map wrapped packages
  // builtins.listToAttrs (map (name: {
      name = name;
      value = (inputs.wrappers.lib.evalModule ./${name}.nix).config.wrap {
        inherit pkgs;
      };
    })
    wrapped-packages)
