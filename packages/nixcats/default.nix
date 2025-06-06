{inputs, ...} @ attrs: let
  inherit (inputs) nixpkgs;
  inherit (inputs.nixCats) utils;
  luaPath = "${./.}";
  forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
  extra_pkg_config = {
    allowUnfree = true;
  };
  dependencyOverlays = [
    (utils.sanitizedPluginOverlay inputs)
  ];

  categoryDefinitions = {
    pkgs,
    # settings,
    # categories,
    # extra,
    # name,
    mkNvimPlugin,
    ...
  } @ packageDef: {
    lspsAndRuntimeDeps = {
      formatter = with pkgs; [
        alejandra
        clang-tools
        # elmPackages.elm-format
        prettierd
        stylua
        # rustfmt
        shfmt
        # sql-formatter
        typstyle
        taplo
      ];
      lsp = with pkgs; [
        # pyright
        nil
        nixd
        tinymist
        # ccls
        # rust-analyzer
        # jdt-language-server
        # haskell-language-server
        lua-language-server
        marksman
        vscode-langservers-extracted
        # tailwindcss-language-server
        # elmPackages.elm-language-server
        # dart
        # nodePackages.typescript-language-server
        # zls
      ];
      image-preview = with pkgs; [
        imagemagick
        curl
        chafa
      ];
      general = {
        fzf = with pkgs;
          [
            ripgrep
            fd
            fzf
            bat
            delta
          ]
          ++ (with pkgs.bat-extras; [
            batdiff
            batman
            batgrep
            batwatch
          ]);
        telescope = with pkgs; [
          ripgrep
          fd
        ];
        git = pkgs.git;
      };
    };

    startupPlugins = {
      general = {
        core = with pkgs.neovimPlugins; [
          lze
          lzextras
        ];
      };
    };

    optionalPlugins = {
      general = {
        core = with pkgs.vimPlugins; [
          repeat
          auto-session
          plenary-nvim
          nvim-web-devicons
          nvim-autopairs
          nvim-surround
          oil-nvim
          nvim-unception
          which-key-nvim
        ];
        completion = with pkgs.vimPlugins; [
          blink-cmp
          colorful-menu-nvim
          blink-compat
          luasnip
          cmp-cmdline
        ];
        treesitter = let
          treesitter-plugins = plugins:
            with plugins; [c cpp clojure cmake comment commonlisp csv dockerfile git_config git_rebase gitattributes gitcommit gitignore go haskell hyprlang java json json5 luadoc make markdown markdown_inline meson nginx nix powershell purescript regex scss sql toml tsx typst vim vimdoc xml yaml yuck zig rust elm lua javascript typescript html css bash python];
        in
          with pkgs.vimPlugins; [
            (nvim-treesitter.withPlugins treesitter-plugins)
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
        fzf = with pkgs.vimPlugins; [
          fzf-lua
        ];
        git = with pkgs.vimPlugins; [
          neogit
          undotree
        ];
      };
      ui = {
        core = with pkgs.vimPlugins; [
          dashboard-nvim
          vim-startuptime
          dressing-nvim
          kanagawa-nvim
          mini-base16
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
      lsp = with pkgs.vimPlugins; [
        nvim-lspconfig
        markdown-preview-nvim
        trouble-nvim
        lazydev-nvim
        nvim-ts-autotag
      ];
      formatter = with pkgs.vimPlugins; [
        conform-nvim
      ];
      image-preview = with pkgs.vimPlugins; [
        image-nvim
      ];
    };

    environmentVariables = {
      general.core = {
        EDITOR = "nvim";
      };
    };
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
          completion = true;
          fzf = true;
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
      extra = {
        # base16colors =
        #   pkgs.lib.filterAttrs
        #   (k: v: builtins.match "base0[0-9A-F]" k != null)
        #   config.lib.stylix.colors.withHashtag;
        nixdExtras = {
          nixpkgs = "import ${pkgs.path} {}";
          get_configs = utils.n2l.types.function-unsafe.mk {
            args = ["type" "path"];
            body = ''return [[import ${./nixd.nix} ${pkgs.path} "]] .. type .. [[" ]] .. (path or "./.")'';
          };
        };
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
          completion = true;
          fzf = true;
          git = true;
        };
        ui.core = true;
      };
      extra = {
        nixdExtras = {
          get_configs = utils.n2l.types.function-unsafe.mk {
            args = ["type" "path"];
            body = ''return [[import ${./nixd.nix} ${pkgs.path} "]] .. type .. [[" ]] .. (path or "./.")'';
          };
          nixpkgs = "import ${pkgs.path} {}";
        };
      };
    };
  };
  defaultPackageName = "nvimcat";
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
        shellHook = ''
        '';
      };
    };
  })
  // (let
    nixosModule = utils.mkNixosModules {
      moduleNamespace = [defaultPackageName];
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
    homeModule = utils.mkHomeModules {
      moduleNamespace = [defaultPackageName];
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
  in {
    overlays =
      utils.makeOverlays luaPath {
        inherit nixpkgs dependencyOverlays extra_pkg_config;
      }
      categoryDefinitions
      packageDefinitions
      defaultPackageName;

    nixosModules.default = nixosModule;
    homeModules.default = homeModule;

    inherit utils nixosModule homeModule;
  })
