{
  pkgs,
  inputs,
  ...
}:
{
  meteorbom = pkgs.callPackage ./meteorbom {};
  wezterm = pkgs.callPackage ./wezterm {};
  yofi = pkgs.callPackage ./yofi {};
  neovide = pkgs.callPackage ./neovide {};

  # dioxus-cli = pkgs.callPackage ./dioxus-cli {};
  # hyprland-py = pkgs.callPackage ./hyprland-py {};
  # typstudio = pkgs.callPackage ./typstudio {};
  # vscode-css-languageservice = pkgs.callPackage ./vscode-css-languageservice {};
}
// (import ./nixcats {inherit inputs;}).packages.${pkgs.system}
