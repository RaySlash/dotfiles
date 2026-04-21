{
  config,
  wlib,
  lib,
  pkgs,
  ...
}: {
  imports = [wlib.wrapperModules.neovim];

  config.package = pkgs.neovim-unwrapped;
  config.binName = "nvim";
  config = {
    info = {
      values = "Neovim wrappped with config";
    };
    specs = {
      general = with pkgs.vimPlugins; [];
      lazy = {
        lazy = true;
        data = with pkgs.vimPlugins; [];
      };
    };
  };
  config.settings.aliases = ["vim" "vi"];
  config.settings.config_directory = ./configs/nvim;
  config.extraPackages = with pkgs; [
    lua
    fzf
    ripgrep
    wl-clipboard
    wl-clipboard-x11
    git
    gcc
    direnv
    cmake
    yarn
    coreutils-full
    tree-sitter
    unzip
    luaPackages.luarocks
  ];
}
