if nixCats and nixCats("colorscheme"):find("catppuccin", 1, true) == 1 then
  require("catppuccin").setup({
    flavour = "macchiato",
    integrations = {
      gitsigns = true,
      lualine = true,
      notify = true,
      mini = true,
      noice = true,
      snacks = true,
      blink_cmp = {
        style = "bordered",
      },
      flash = true,
      indent_blankline = {
        enabled = true,
        scope_color = "mauve", -- catppuccin color (eg. `lavender`) Default: text
        colored_indent_levels = false,
      },
      treesitter_context = true,
      markview = true,
      rendered_markdown = true,
    },
  })
end
vim.cmd.colorscheme(nixCats("colorscheme"))

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
