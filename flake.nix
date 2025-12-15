# Copyright (c) 2023 BirdeeHub
# Licensed under the MIT license
# Welcome to the main example config of nixCats!
# there is a minimal flake the starter templates use
# within the nix directory without the nixpkgs input,
# but this one would work too!
# Every config based on nixCats is a full nixCats.
# This example config doesnt use lazy.nvim, and
# it loads everything via nix.
# It has some useful tricks
# in it, especially for lsps, so if you have any questions,
# first look through the docs, and then here!
# It has examples of most of the things you would want to do
# in your main nvim configuration.
# If there is still not adequate info, ask in discussions
# on the nixCats repo (or open a PR to add the info to the help!)
{
  description = "A Lua-natic's neovim flake, with extra cats! nixCats!";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";
    nixCats.url = "github:BirdeeHub/nixCats-nvim";

    nvim-treesitter-main.url = "github:iofq/nvim-treesitter-main";

    # Rust
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bacon = {
      url = "github:Canop/bacon";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    bacon-ls = {
      url = "github:crisidev/bacon-ls";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    neovim-nightly-overlay = {
      url = "github:nix-community/neovim-nightly-overlay";
    };
    # see :help nixCats.flake.inputs
    # If you want your plugin to be loaded by the standard overlay,
    # i.e. if it wasnt on nixpkgs, but doesnt have an extra build step.
    # Then you should name it "plugins-something"
    # If you wish to define a custom build step not handled by nixpkgs,
    # then you should name it in a different format, and deal with that in the
    # overlay defined for custom builds in the overlays directory.
    # for specific tags, branches and commits, see:
    # https://nixos.org/manual/nix/stable/command-ref/new-cli/nix3-flake.html#examples

    # No longer fetched to avoid forcing people to import it, but this remains here as a tutorial.
    # How to import it into your config is shown farther down in the startupPlugins set.
    # You put it here like this, and then below you would use it with `pkgs.neovimPlugins.hlargs`

    "plugins-tiny-inline-diagnostic" = {
      url = "github:rachartier/tiny-inline-diagnostic.nvim";
      flake = false;
    };

    "plugins-blink-cmp-copilot" = {
      url = "github:giuxtaposition/blink-cmp-copilot";
      flake = false;
    };
  };

  # see :help nixCats.flake.outputs
  outputs = {
    self,
    nixpkgs,
    ...
  } @ inputs: let
    inherit (inputs.nixCats) utils;
    luaPath = ./.;
    # this is flake-utils eachSystem
    forEachSystem = utils.eachSystem nixpkgs.lib.platforms.all;
    # the following extra_pkg_config contains any values
    # which you want to pass to the config set of nixpkgs
    # import nixpkgs { config = extra_pkg_config; inherit system; }
    # will not apply to module imports
    # as that will have your system values
    extra_pkg_config = {
      allowUnfree = true;
    };
    # Management of the system variable is one of the harder parts of using flakes.

    # so I have done it here in an interesting way to keep it out of the way.
    # It gets resolved within the builder itself, and then passed to your
    # categoryDefinitions and packageDefinitions.

    # this allows you to use ${pkgs.system} whenever you want in those sections
    # without fear.

    # see :help nixCats.flake.outputs.overlays
    dependencyOverlays =
      /*
      (import ./overlays inputs) ++
      */
      [
        # This overlay grabs all the inputs named in the format
        # `plugins-<pluginName>`
        # Once we add this overlay to our nixpkgs, we are able to
        # use `pkgs.neovimPlugins`, which is a set of our plugins.
        (utils.standardPluginOverlay inputs)
        # add any other flake overlays here.
        inputs.nvim-treesitter-main.overlays.default
        inputs.fenix.overlays.default
        # when other people mess up their overlays by wrapping them with system,
        # you may instead call this function on their overlay.
        # it will check if it has the system in the set, and if so return the desired overlay
        # (utils.fixSystemizedOverlay inputs.codeium.overlays
        #   (system: inputs.codeium.overlays.${system}.default)
        # )

        (
          final: prev: {
            vimPlugins = prev.vimPlugins.extend (
              f: p: {
                nvim-treesitter = p.nvim-treesitter.withAllGrammars; # or withPlugins...
                # also redefine nvim-treesitter-textobjects (any other plugins that depend on nvim-treesitter)
                nvim-treesitter-textobjects = p.nvim-treesitter-textobjects.overrideAttrs {
                  dependencies = [f.nvim-treesitter];
                };
                nvim-treesitter-context = p.nvim-treesitter-context.overrideAttrs {
                  dependencies = [f.nvim-treesitter];
                };
                flash-nvim = p.flash-nvim.overrideAttrs {
                  dependencies = [f.nvim-treesitter];
                };
                blink-cmp = p.blink-cmp.overrideAttrs {
                  dependencies = [f.nvim-treesitter];
                };
              }
            );
          }
        )
      ];

    # see :help nixCats.flake.outputs.categories
    # and
    # :help nixCats.flake.outputs.categoryDefinitions.scheme
    categoryDefinitions = {
      pkgs,
      settings,
      categories,
      extra,
      name,
      mkPlugin,
      ...
    } @ packageDef: {
      # to define and use a new category, simply add a new list to a set here,
      # and later, you will include categoryname = true; in the set you
      # provide when you build the package using this builder function.
      # see :help nixCats.flake.outputs.packageDefinitions for info on that section.

      # lspsAndRuntimeDeps:
      # this section is for dependencies that should be available
      # at RUN TIME for plugins. Will be available to PATH within neovim terminal
      # this includes LSPs
      lspsAndRuntimeDeps = {
        # some categories of stuff.
        general = with pkgs; [
          universal-ctags
          ripgrep
          fd
        ];
        # these names are arbitrary.
        lint = with pkgs; [
          # nix
          statix

          # yaml
          yamllint
        ];
        # and easily check if they are included in lua
        format = with pkgs; [
          # nix
          alejandra

          # lua
          stylua

          # python
          ruff

          # yaml
          yamlfmt
          yamlfix
        ];

        neonixdev = {
          # also you can do this.
          inherit (pkgs) nix-doc lua-language-server nixd nil;
          # and each will be its own sub category
        };

        python = with pkgs; [
          python313Packages.python-lsp-server
          python313Packages.python-lsp-ruff
          python313Packages.rope
          python313Packages.pylsp-rope

          basedpyright
          ty
        ];

        bash = with pkgs; [
          bash-language-server
          shfmt
          shellcheck
        ];

        markdown = with pkgs; [
          marksman
        ];

        rust = with pkgs; [
          rust-analyzer-nightly
          graphviz
          (fenix.complete.withComponents [
            "cargo"
            "clippy"
            "rust-src"
            "rustc"
            "rustfmt"
          ])
          inputs.bacon.defaultPackage.${pkgs.stdenv.hostPlatform.system}
          inputs.bacon-ls.defaultPackage.${pkgs.stdenv.hostPlatform.system}
          taplo
        ];

        yaml = with pkgs; [
          yaml-language-server
        ];
      };

      # This is for plugins that will load at startup without using packadd:
      startupPlugins = {
        general = with pkgs.vimPlugins; {
          # you can make subcategories!!!
          # (always isnt a special name, just the one I chose for this subcategory)
          always = [
            lze
            lzextras
            vim-repeat
            plenary-nvim
            (nvim-notify.overrideAttrs {doCheck = false;}) # TODO: remove overrideAttrs after check is fixed
          ];
          extra = [
            mini-files
            mini-icons
          ];
        };
        # You can retreive information from the
        # packageDefinitions of the package this was packaged with.
        # :help nixCats.flake.outputs.categoryDefinitions.scheme
        themer = with pkgs.vimPlugins; (
          builtins.getAttr (categories.colorscheme or "onedark") {
            # Theme switcher without creating a new category
            "onedark" = onedark-nvim;
            "catppuccin" = catppuccin-nvim;
            "catppuccin-macchiato" = catppuccin-nvim;
            "catppuccin-mocha" = catppuccin-nvim;
            "tokyonight" = tokyonight-nvim;
            "tokyonight-day" = tokyonight-nvim;
          }
        );
      };

      # not loaded automatically at startup.
      # use with packadd and an autocommand in config to achieve lazy loading
      # or a tool for organizing this like lze or lz.n!
      # to get the name packadd expects, use the
      # `:NixCats pawsible` command to see them all
      optionalPlugins = {
        lint = with pkgs.vimPlugins; [
          nvim-lint
        ];
        format = with pkgs.vimPlugins; [
          conform-nvim
        ];
        markdown = with pkgs.vimPlugins; [
          markdown-preview-nvim
          markview-nvim
        ];
        neonixdev = with pkgs.vimPlugins; [
          lazydev-nvim
        ];
        rust = with pkgs.vimPlugins; [
          crates-nvim
          rustaceanvim
        ];
        general = {
          blink = with pkgs.vimPlugins; [
            luasnip
            cmp-cmdline
            blink-cmp
            blink-compat
            blink-pairs
            colorful-menu-nvim
            copilot-lua
            blink-copilot
            pkgs.neovimPlugins.blink-cmp-copilot
            windsurf-nvim
          ];
          treesitter = with pkgs.vimPlugins; [
            nvim-treesitter-textobjects
            nvim-treesitter.withAllGrammars
            nvim-treesitter-context
          ];
          always = with pkgs.vimPlugins; [
            nvim-lspconfig
            lualine-nvim
            gitsigns-nvim
            vim-sleuth
            vim-fugitive
            vim-rhubarb
            nvim-surround
          ];
          extra = with pkgs.vimPlugins; [
            noice-nvim
            nvim-notify
            catppuccin-nvim
            which-key-nvim
            ts-comments-nvim
            undotree
            indent-blankline-nvim
            flash-nvim
            snipe-nvim
            hover-nvim
            snacks-nvim
            # If it was included in your flake inputs as plugins-hlargs,
            # this would be how to add that plugin in your config.
            pkgs.neovimPlugins.tiny-inline-diagnostic
          ];
        };
      };

      # shared libraries to be added to LD_LIBRARY_PATH
      # variable available to nvim runtime
      sharedLibraries = {
        general = with pkgs; [
          # <- this would be included if any of the subcategories of general are
          # libgit2
        ];
      };

      # environmentVariables:
      # this section is for environmentVariables that should be available
      # at RUN TIME for plugins. Will be available to path within neovim terminal
      environmentVariables = {
      };

      # If you know what these are, you can provide custom ones by category here.
      # If you dont, check this link out:
      # https://github.com/NixOS/nixpkgs/blob/master/pkgs/build-support/setup-hooks/make-wrapper.sh
      extraWrapperArgs = {
      };

      # lists of the functions you would have passed to
      # python.withPackages or lua.withPackages
      # do not forget to set `hosts.python3.enable` in package settings

      # get the path to this python environment
      # in your lua config via
      # vim.g.python3_host_prog
      # or run from nvim terminal via :!<packagename>-python3
      python3.libraries = {
        test = _: [];
      };
      # populates $LUA_PATH and $LUA_CPATH
      extraLuaPackages = {
        general = [(_: [])];
      };

      # see :help nixCats.flake.outputs.categoryDefinitions.default_values
      # this will enable test.default and debug.default
      # if any subcategory of test or debug is enabled
      # WARNING: use of categories argument in this set will cause infinite recursion
      # The categories argument of this function is the FINAL value.
      # You may use it in any of the other sets.
      extraCats = {
      };
    };

    # packageDefinitions:

    # Now build a package with specific categories from above
    # All categories you wish to include must be marked true,
    # but false may be omitted.
    # This entire set is also passed to nixCats for querying within the lua.
    # It is directly translated to a Lua table, and a get function is defined.
    # The get function is to prevent errors when querying subcategories.

    # see :help nixCats.flake.outputs.packageDefinitions
    packageDefinitions = {
      # the name here is the name of the package
      # and also the default command name for it.
      nixCats = {
        pkgs,
        name,
        ...
      } @ misc: {
        # these also recieve our pkgs variable
        # see :help nixCats.flake.outputs.packageDefinitions
        settings = {
          suffix-path = true;
          suffix-LD = true;
          # The name of the package, and the default launch name,
          # and the name of the .desktop file, is `nixCats`,
          # or, whatever you named the package definition in the packageDefinitions set.
          # WARNING: MAKE SURE THESE DONT CONFLICT WITH OTHER INSTALLED PACKAGES ON YOUR PATH
          # That would result in a failed build, as nixos and home manager modules validate for collisions on your path
          aliases = ["vim" "vimcat"];

          # explained below in the `regularCats` package's definition
          # OR see :help nixCats.flake.outputs.settings for all of the settings available
          wrapRc = true;
          configDirName = "nixCats-nvim";
          neovim-unwrapped = inputs.neovim-nightly-overlay.packages.${pkgs.stdenv.hostPlatform.system}.neovim;
          hosts.python3.enable = true;
          hosts.node.enable = true;
        };
        # enable the categories you want from categoryDefinitions
        categories = {
          general = true;
          lint = true;
          format = true;

          neonixdev = true;
          python = true;
          bash = true;
          rust = true;
          markdown = true;
          yaml = true;

          # enabling this category will enable the go category,
          # and ALSO debug.go and debug.default due to our extraCats in categoryDefinitions.
          # go = true; # <- disabled but you could enable it with override or module on install

          # this does not have an associated category of plugins,
          # but lua can still check for it
          lspDebugMode = false;
          # you could also pass something else:
          # see :help nixCats
          themer = true;
          colorscheme = "catppuccin-macchiato";
        };
        extra = {
          # to keep the categories table from being filled with non category things that you want to pass
          # there is also an extra table you can use to pass extra stuff.
          # but you can pass all the same stuff in any of these sets and access it in lua
          nixdExtras = {
            nixpkgs = ''import ${pkgs.path} {}'';
            # or inherit nixpkgs;
          };
        };
      };
    };

    defaultPackageName = "nixCats";
    # I did not here, but you might want to create a package named nvim.
    # defaultPackageName is also passed to utils.mkNixosModules and utils.mkHomeModules
    # and it controls the name of the top level option set.
    # If you made a package named `nixCats` your default package as we did here,
    # the modules generated would be set at:
    # config.nixCats = {
    #   enable = true;
    #   packageNames = [ "nixCats" ]; # <- the packages you want installed
    #   <see :h nixCats.module for options>
    # }
    # In addition, every package exports its own module via passthru, and is overrideable.
    # so you can yourpackage.homeModule and then the namespace would be that packages name.
  in
    # you shouldnt need to change much past here, but you can if you wish.
    # but you should at least eventually try to figure out whats going on here!
    # see :help nixCats.flake.outputs.exports
    forEachSystem (system: let
      # and this will be our builder! it takes a name from our packageDefinitions as an argument, and builds an nvim.
      nixCatsBuilder =
        utils.baseBuilder luaPath {
          # we pass in the things to make a pkgs variable to build nvim with later
          inherit nixpkgs system dependencyOverlays extra_pkg_config;
          # and also our categoryDefinitions and packageDefinitions
        }
        categoryDefinitions
        packageDefinitions;
      # call it with our defaultPackageName
      defaultPackage = nixCatsBuilder defaultPackageName;

      # this pkgs variable is just for using utils such as pkgs.mkShell
      # within this outputs set.
      pkgs = import nixpkgs {inherit system;};
      # The one used to build neovim is resolved inside the builder
      # and is passed to our categoryDefinitions and packageDefinitions
    in {
      # these outputs will be wrapped with ${system} by utils.eachSystem

      # this will generate a set of all the packages
      # in the packageDefinitions defined above
      # from the package we give it.
      # and additionally output the original as default.
      packages = utils.mkAllWithDefault defaultPackage;

      # choose your package for devShell
      # and add whatever else you want in it.
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
      # we also export a nixos module to allow reconfiguration from configuration.nix
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
      # and the same for home manager
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
      # these outputs will be NOT wrapped with ${system}

      # this will make an overlay out of each of the packageDefinitions defined above
      # and set the default overlay to the one named here.
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
      inherit (utils) templates;
    });
}
