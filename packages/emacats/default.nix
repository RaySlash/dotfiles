{inputs}: let
  utils = inputs.self.hub.lib;
in
  utils.forEachSystem (system: let
    pkgs = utils.mkPkgs {
      inherit inputs;
      system = system;
    };

    formatters = with pkgs; [
      bash-language-server
      lua-language-server
      nixd
      marksman
      vscode-langservers-extracted
      typst
      tinymist
      taplo-lsp
      cmake-language-server
      yaml-language-server
    ];
    lsp = with pkgs; [
      clang-tools
      prettierd
      taplo
      sql-formatter
      stylua
      shfmt
      alejandra
      tidyp
      typstyle
      gawk
    ];
    addons = with pkgs; [
      coreutils-full
      ripgrep
      fd
    ];
  in {
    packages.emacats =
      (pkgs.emacsPackagesFor pkgs.emacs-git-pgtk).emacsWithPackages
      (epkgs:
        formatters
        ++ lsp
        ++ addons);
  })
