{
  pkgs,
  inputs,
  ...
}: {
  meteorbom = pkgs.callPackage ./meteorbom {};
  wezterm = pkgs.callPackage ./wezterm {};
  yofi = pkgs.callPackage ./yofi {};

  # `./nixcats` exports nixosModule, homeModule and pkgs
  # nvimcat = (import ./nixcats {inherit inputs;}).packages.${pkgs.system}.nvimcat;
  # nvimcat-minimal = (import ./nixcats {inherit inputs;}).packages.nvimcat-minimal.${pkgs.system};

  # dioxus-cli = pkgs.callPackage ./dioxus-cli {};
  # hyprland-py = pkgs.callPackage ./hyprland-py {};
  # typstudio = pkgs.callPackage ./typstudio {};
  # vscode-css-languageservice = pkgs.callPackage ./vscode-css-languageservice {};
}
