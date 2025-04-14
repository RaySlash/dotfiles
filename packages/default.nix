{
  pkgs,
  inputs,
  ...
}: let
  packages = [
    "meteorbom"
    "wezterm"
    "yofi"
    "neovide"
    # dioxus-cli
    # hyprland-py
    # typstudio
    # vscode-css-languageservice
  ];
in
  builtins.listToAttrs (map (name: {
      name = name;
      value = pkgs.callPackage ./${name} {};
    })
    packages)
  // (import ./nixcats {inherit inputs;}).packages.${pkgs.system}
