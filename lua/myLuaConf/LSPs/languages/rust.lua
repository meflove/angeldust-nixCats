return {
  {
    "bacon-ls",
    lsp = {
      filetypes = { "rust" },
      settings = {
        ["bacon-ls"] = {
          updateOnSave = true,
          updateOnSaveWaitMillis = 1000,
        },
      },
    },
  },
  {
    "rustaceanvim",
    for_cat = "general.rust",
    ft = { "rust" },
    lazy = false,
    init = function(plugin)
      vim.g.rustaceanvim = {
        server = {
          on_attach = function(client, bufnr) end,
          default_settings = {
            ["rust-analyzer"] = {
              cargo = {
                allFeatures = true,
                loadOutDirsFromCheck = true,
                buildScripts = {
                  enable = true,
                },
              },
              checkOnSave = {
                enable = false,
              },
              diagnostics = {
                enable = false,
              },
              procMacro = {
                enable = true,
              },
              files = {
                exclude = {
                  ".direnv",
                  ".git",
                  ".jj",
                  ".github",
                  ".gitlab",
                  "bin",
                  "node_modules",
                  "target",
                  "venv",
                  ".venv",
                },
                watcher = "client",
              },
            },
          },
        },
      }
    end,
  },
  {
    "crates.nvim",
    for_cat = "general.rust",
    event = { "BufRead Cargo.toml" },
    after = function(plugin)
      require("crates").setup({
        completion = {
          crates = {
            enabled = true,
          },
        },
        lsp = {
          enabled = true,
          actions = true,
          completion = true,
          hover = true,
        },
      })
    end,
  },
  {
    "taplo",
    lsp = {
      filetypes = { "toml" },
      settings = {
        taplo = {},
      },
    },
  },
}
