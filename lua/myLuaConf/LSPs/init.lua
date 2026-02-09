-- Set LSP log level if in debug mode
local catUtils = require("nixCatsUtils")
if catUtils.isNixCats and nixCats("lspDebugMode") then
  vim.lsp.set_log_level("debug")
end

require("lze").load({
  {
    "nvim-lspconfig",
    lsp = function(plugin)
      vim.lsp.config(plugin.name, plugin.lsp or {})
      vim.lsp.enable(plugin.name)
    end,
    before = function(plugin)
      vim.lsp.config("*", {
        -- capabilities = capabilities,
        on_attach = require("myLuaConf.LSPs.on_attach"),
      })
    end,
  },
  { import = "myLuaConf.LSPs.languages.lua" },
  { import = "myLuaConf.LSPs.languages.nix" },
  { import = "myLuaConf.LSPs.languages.python" },
  { import = "myLuaConf.LSPs.languages.bash" },
  { import = "myLuaConf.LSPs.languages.md" },
  { import = "myLuaConf.LSPs.languages.rust" },
  { import = "myLuaConf.LSPs.languages.yaml" },
  { import = "myLuaConf.LSPs.languages.json" },
  { import = "myLuaConf.LSPs.languages.typescript" },
})
