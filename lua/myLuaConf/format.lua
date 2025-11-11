require("lze").load({
  {
    "conform.nvim",
    for_cat = "format",
    -- cmd = { "" },
    event = "BufWritePre",
    -- ft = "",
    -- colorscheme = "",
    after = function(plugin)
      local conform = require("conform")

      conform.setup({
        formatters_by_ft = {
          -- NOTE: download some formatters in lspsAndRuntimeDeps
          -- and configure them here
          lua = { "stylua" },
          -- go = { "gofmt", "golint" },
          -- templ = { "templ" },
          -- Conform will run multiple formatters sequentially
          python = { "ruff_format", "ruff_organize_imports" },
          -- Use a sub-list to run only the first available formatter
          -- javascript = { { "prettierd", "prettier" } },
          nix = { "alejandra" },
          sh = { "shfmt" },
        },

        format_on_save = {
          -- These options will be passed to conform.format()
          timeout_ms = 500,
          lsp_format = "fallback",
        },
      })
    end,
  },
})
