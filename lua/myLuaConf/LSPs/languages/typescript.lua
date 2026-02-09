return {
  {
    "typescript-tools.nvim",
    for_cat = "typescript",
    ft = { "typescript", "javascript", "typescriptreact", "javascriptreact" },
    after = function(plugin)
      require("typescript-tools").setup({
        on_attach = function(client, bufnr)
          client.server_capabilities.documentFormattingProvider = false
          client.server_capabilities.documentRangeFormattingProvider = false
        end,
        settings = {
          jsx_close_tag = {
            enable = true,
            filetypes = { "javascriptreact", "typescriptreact" },
          },
        },
      })
    end,
  },
}
