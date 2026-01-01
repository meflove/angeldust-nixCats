require("lze").load({
  {
    "nvim-lint",
    for_cat = "lint",
    -- cmd = { "" },
    event = "FileType",
    -- ft = "",
    -- keys = "",
    -- colorscheme = "",
    after = function(plugin)
      local lint = require("lint")

      lint.linters_by_ft = {
        -- NOTE: download some linters in lspsAndRuntimeDeps
        -- and configure them here
        -- markdown = {'vale',},
        -- javascript = { 'eslint' },
        -- typescript = { 'eslint' },
        nix = { "statix" },
        -- python = { "pylint" },
        yaml = { "yamllint" },
        json = { "jsonlint" },
      }

      vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "BufReadPost", "InsertLeave" }, {
        callback = function()
          lint.try_lint()
        end,
      })
    end,
  },
})
