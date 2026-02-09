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
          nix = { "alejandra" },
          sh = { "shfmt" },
          yaml = { "yamlfmt", "yamlfix" },
          json = { "json_repair", "fixjson" },
          html = { "prettierd" },
          javascript = { "prettierd" },
          javascriptreact = { "prettierd" },
          markdown = { "prettierd" },
          typescript = { "prettierd" },
          typescriptreact = { "prettierd" },
          ["*"] = { "trim_whitespace" },
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
