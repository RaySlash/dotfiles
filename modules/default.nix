{inputs, ...}: let
  nvimcat = import ./nvimcat {inherit inputs;};
in {
  osModules = {
    emacs = import ./emacs/module.nix;
    hyprland-custom = import ./hyprland/module.nix;
    nixcats = nvimcat.nixosModules.default;
    nix-essentials = import ./nix/module.nix;
    theme-custom = import ./themes/module.nix;
    zsh-custom = import ./zsh/module.nix;
    smj = import ./users/smj/module.nix;
  };

  homeModules = {
    emacs-addons = import ./emacs/home;
    firefox-addons = import ./firefox/home;
    hyprland-addons = import ./hyprland/home;
    lazyvim = import ./lazynvim/home;
    nixcats = nvimcat.homeModules.default;
    neovide = import ./neovide/home.nix;
    nix-addons = import ./nix/home.nix;
    theme-addons = import ./themes/home;
    wezterm-addons = import ./wezterm/home;
    kitty = import ./kitty/home;
    smj = import ./users/smj/home;
  };

  pkgs = {nvimcat = nvimcat.packages;};
}
