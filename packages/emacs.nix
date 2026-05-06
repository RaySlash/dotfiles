{
  config,
  wlib,
  lib,
  pkgs,
  ...
}:
{
  imports = [ wlib.wrapperModules.emacs ];

  config.configFile = builtins.readFile ./configs/emacs-init.el;
  config.userDirectory = "~/.emacs.d";
  config.package = pkgs.emacs-pgtk;
  config.extraPackages = with pkgs; [
    # Formatters
    elmPackages.elm-format
    cmake-format
    sql-formatter
    clang-tools
    gdtoolkit_4
    gawk
    html-tidy
    jq
    meson-tools
    stylua
    shfmt
    prettierd
    nixfmt
    black
    tidyp
    shfmt
    stylua
    typstyle
    taplo
    rustfmt
    # LSPs
    ccls
    nil
    nixd
    pyright
    bash-language-server
    lua-language-server
    taplo
    typstyle
    gawk
    marksman
    prettierd
    vscode-langservers-extracted
    tinymist
    cmake-language-server
    yaml-language-server
    haskell-language-server
    elmPackages.elm-language-server
    #Tools
    typst
    coreutils-full
    ripgrep
    fzf
    fd
  ];
  config.emacsPackages =
    epkgs: with epkgs; [
      pdf-tools
      nerd-icons
    ];
}
