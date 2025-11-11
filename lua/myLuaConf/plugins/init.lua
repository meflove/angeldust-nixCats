local colorschemeName = nixCats("colorscheme")
if not require("nixCatsUtils").isNixCats then
  colorschemeName = "onedark"
end
-- Could I lazy load on colorscheme with lze?
-- sure. But I was going to call vim.cmd.colorscheme() during startup anyway
-- this is just an example, feel free to do a better job!
vim.cmd.colorscheme(colorschemeName)

local ok, notify = pcall(require, "notify")
if ok then
  notify.setup({
    on_open = function(win)
      vim.api.nvim_win_set_config(win, { focusable = true })
    end,
  })
  vim.notify = notify
  vim.keymap.set("n", "<Esc>", function()
    notify.dismiss({ silent = true })
  end, { desc = "dismiss notify popup and clear hlsearch" })
end

require("lze").load({
  { import = "myLuaConf.plugins.ui" },
  { import = "myLuaConf.plugins.editor" },
  { import = "myLuaConf.plugins.git" },
  { import = "myLuaConf.plugins.utilities" },
  { import = "myLuaConf.plugins.treesitter" },
  { import = "myLuaConf.plugins.completion" },
  { import = "myLuaConf.plugins.lualine" },
})
