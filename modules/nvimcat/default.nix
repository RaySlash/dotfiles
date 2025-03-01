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
    mkNvimPlugin, # (mkNvimPlugin inputs.plugins-neogit "neogit")
    ...
  } @ packageDef: {
    lspsAndRuntimeDeps = {
      formatter = with pkgs; [
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
      ];
      lsp = with pkgs; [
        nil
        nixd
        ccls
        rust-analyzer
        jdt-language-server
        haskell-language-server
        lua-language-server
        marksman
        vscode-langservers-extracted
        tailwindcss-language-server
        elmPackages.elm-language-server
        dart
        nodePackages.typescript-language-server
        zls
      ];
      image-preview = with pkgs; [
        imagemagick
        curl
      ];
    };

    startupPlugins = {
      lsp = with pkgs.vimPlugins; [
        nvim-lspconfig
        markdown-preview-nvim
        trouble-nvim
        lazydev-nvim
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
      formatter = with pkgs.vimPlugins; [
        formatter-nvim
      ];
      ui = {
        core = with pkgs.vimPlugins; [
          dashboard-nvim
          dressing-nvim
          noice-nvim
          nui-nvim
          kanagawa-nvim
          lualine-nvim
          leap-nvim
          statuscol-nvim
        ];
        addons = with pkgs.vimPlugins; [
          render-markdown-nvim
          nvim-highlight-colors
          nvim-colorizer-lua
        ];
      };
      image-preview = with pkgs.vimPlugins; [
        image-nvim
      ];
      general = {
        core = with pkgs.vimPlugins; [
          repeat
          plenary-nvim
          nvim-web-devicons
          nvim-autopairs
          mini-surround
          oil-nvim
          nvim-unception
          which-key-nvim
          auto-session
        ];
        treesitter = with pkgs.vimPlugins; [
          nvim-treesitter.withAllGrammars
          nvim-treesitter-textobjects
          nvim-ts-context-commentstring
          nvim-treesitter-context
          yuck-vim
        ];
        telescope = with pkgs.vimPlugins; [
          telescope-nvim
          telescope-fzy-native-nvim
          telescope-frecency-nvim
          telescope-undo-nvim
        ];
        git = with pkgs.vimPlugins; [
          neogit
          undotree
        ];
      };
    };

    sharedLibraries = {
      general = {
        core = with pkgs; [
          libgit2
        ];
      };
      lsp = with pkgs; [
        raylib
      ];
    };

    environmentVariables = {
      general.core = {
        EDITOR = "nvim";
      };
    };

    extraWrapperArgs = {
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      test = [''--set CATTESTVAR2 "It worked again!"''];
    };

    extraPython3Packages = {test = _: [];};
    extraLuaPackages = {test = [(_: [])];};
  };

  packageDefinitions = {
    nvimcat = {pkgs, ...}: {
      settings = {
        wrapRc = true;
        aliases = ["vi" "vim" "nvim"];
        neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      };
      categories = {
        general = {
          core = true;
          treesitter = true;
          telescope = true;
          git = true;
        };
        ui = {
          core = true;
          addons = true;
        };
        image-preview = true;
        formatter = true;
        lsp = true;
      };
    };
    nvim-minimal = {pkgs, ...}: {
      settings = {
        wrapRc = true;
        aliases = ["vi" "vim" "nvim"];
        neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.system}.default;
      };
      categories = {
        general = {
          core = true;
          treesitter = true;
          telescope = true;
          git = true;
        };
        ui.core = true;
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
