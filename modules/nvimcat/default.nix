# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
{inputs, ...} @ attrs: let
  inherit (inputs) nixpkgs-unstable;
  inherit (inputs.nixCats) utils;
  nixpkgs = nixpkgs-unstable;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  extra_pkg_config = {
    allowUnfree = true;
  };
  inherit
    (forEachSystem (system: let
      dependencyOverlays =
        # see :help nixCats.flake.outputs.overlays
        # (import ./overlays inputs) ++
        [
          (utils.standardPluginOverlay inputs)
        ];
    in {inherit dependencyOverlays;}))
    dependencyOverlays
    ;

  categoryDefinitions = {
    pkgs,
    mkNvimPlugin,
    ...
  } @ packageDef: {
    lspsAndRuntimeDeps = {
      general = with pkgs; [
        # Formatters
        alejandra
        clang-tools
        elmPackages.elm-format
        prettierd
        stylua
        rustfmt
        leptosfmt
        shfmt
        sql-formatter
        taplo

        # Lsp
        nil
        nixd
        ccls
        rust-analyzer
        jdt-language-server
        haskell-language-server
        lua-language-server
        vscode-langservers-extracted
        tailwindcss-language-server
        elmPackages.elm-language-server
        dart
        nodePackages.typescript-language-server
        zls

        # Image Previews
        imagemagick
        curl
      ];
    };

    startupPlugins = {
      git = [
        # (mkNvimPlugin inputs.plugins-neogit "neogit")
        pkgs.vimPlugins.neogit
      ];
      lsp = with pkgs.vimPlugins; [
        nvim-lspconfig
        markdown-preview-nvim
        trouble-nvim
        lazydev-nvim
        formatter-nvim
        luasnip
        nvim-cmp
        cmp_luasnip
        lspkind-nvim
        nvim-ts-autotag
        cmp-nvim-lsp
        cmp-nvim-lsp-signature-help
        cmp-buffer
        cmp-path
        cmp-nvim-lua
        cmp-cmdline
        cmp-cmdline-history
      ];
      ui = with pkgs.vimPlugins; [
        render-markdown-nvim
        dressing-nvim
        noice-nvim
        nui-nvim
        nvim-highlight-colors
        kanagawa-nvim
        lualine-nvim
        statuscol-nvim
        nvim-treesitter-context
        nvim-colorizer-lua
        oil-nvim
      ];
      deps = with pkgs.vimPlugins; [
        repeat
        image-nvim
        plenary-nvim
        nvim-web-devicons
      ];
      langs = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        yuck-vim
      ];
      general = with pkgs.vimPlugins; [
        nvim-autopairs
        mini-surround
        telescope-nvim
        telescope-fzy-native-nvim
        telescope-frecency-nvim
        undotree
        telescope-undo-nvim
        nvim-treesitter-textobjects
        nvim-ts-context-commentstring
        nvim-unception
        which-key-nvim
      ];
    };

    # optionalPlugins = {
    #   gitPlugins = with pkgs.neovimPlugins; [];
    #   general = with pkgs.vimPlugins; [];
    # };

    sharedLibraries = {general = with pkgs; [libgit2];};

    environmentVariables = {general = {EDITOR = "nvim";};};

    extraWrapperArgs = {
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      test = [''--set CATTESTVAR2 "It worked again!"''];
    };

    extraPython3Packages = {test = _: [];};
    extraLuaPackages = {test = [(_: [])];};
  };

  packageDefinitions = {
    # see :help nixCats.flake.outputs.settings
    nvimcat = {pkgs, ...}: {
      settings = {
        wrapRc = true;
        aliases = ["vi" "vim" "nvim"];
        # neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      };
      categories = {
        general = true;
        git = true;
        ui = true;
        lsp = true;
        deps = true;
        langs = true;
      };
      extra = {};
    };
    nvim-minimal = {pkgs, ...}: {
      settings = {
        wrapRc = true;
        aliases = ["vim" "nvim"];
      };
      categories = {
        general = true;
        deps = true;
        langs = true;
      };
    };
  };
  defaultPackageName = "nvimcat";
  # see :help nixCats.flake.outputs.exports
in
  forEachSystem (system: let
    nixCatsBuilder =
      utils.baseBuilder luaPath {
        inherit system dependencyOverlays extra_pkg_config nixpkgs;
      }
      categoryDefinitions
      packageDefinitions;
    defaultPackage = nixCatsBuilder defaultPackageName;
    pkgs = import nixpkgs {inherit system;};
  in {
    packages = utils.mkAllWithDefault defaultPackage;

    devShells = {
      default = pkgs.mkShell {
        name = defaultPackageName;
        packages = [defaultPackage];
        inputsFrom = [];
        shellHook = "";
      };
    };
  })
  // {
    overlays =
      utils.makeOverlays luaPath {
        inherit nixpkgs dependencyOverlays extra_pkg_config;
      }
      categoryDefinitions
      packageDefinitions
      defaultPackageName;

    nixosModules.default = utils.mkNixosModules {
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
    homeModules.default = utils.mkHomeModules {
      inherit
        defaultPackageName
        dependencyOverlays
        luaPath
        categoryDefinitions
        packageDefinitions
        extra_pkg_config
        nixpkgs
        ;
    };
    inherit utils;
    inherit (utils) templates;
  }
