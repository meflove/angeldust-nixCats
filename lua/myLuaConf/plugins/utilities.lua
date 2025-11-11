return {
  {
    "tiny-inline-diagnostic",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("tiny-inline-diagnostic").setup({
        options = {
          multiple_diag_under_cursor = true,
          show_all_diags_on_cursorline = true,
          multilines = true,
        },
      })
    end,
  },
  {
    "markdown-preview.nvim",
    for_cat = "markdown",
    cmd = { "MarkdownPreview", "MarkdownPreviewStop", "MarkdownPreviewToggle" },
    ft = "markdown",
    keys = {
      { "<leader>mp", "<cmd>MarkdownPreview <CR>", mode = { "n" }, noremap = true, desc = "markdown preview" },
      {
        "<leader>ms",
        "<cmd>MarkdownPreviewStop <CR>",
        mode = { "n" },
        noremap = true,
        desc = "markdown preview stop",
      },
      {
        "<leader>mt",
        "<cmd>MarkdownPreviewToggle <CR>",
        mode = { "n" },
        noremap = true,
        desc = "markdown preview toggle",
      },
    },
    before = function(plugin)
      vim.g.mkdp_auto_close = 0
    end,
  },
  {
    "markview.nvim",
    for_cat = "markdown",
    ft = "markdown",
    cmd = { "Markview" },
    after = function(plugin)
      require("markview").setup({})
    end,
  },
  {
    "snipe.nvim",
    for_cat = "general.extra",
    keys = {
      {
        "gb",
        function()
          require("snipe").open_buffer_menu()
        end,
        desc = "Open Snipe buffer menu",
        noremap = true,
      },
    },
    after = function(plugin)
      require("snipe").setup({
        ui = { position = "center" },
        hints = {
          -- Charaters to use for hints
          -- make sure they don't collide with the navigation keymaps
          -- If you remove `j` and `k` from below, you can navigate in the plugin
          -- dictionary = "sadflewcmpghio",
          dictionary = "asfghl;wertyuiop",
        },
        navigate = {
          -- In case you changed your mind, provide a keybind that lets you
          -- cancel the snipe and close the window.
          cancel_snipe = {
            "<esc>",
            "q",
          },

          -- Remove "j" and "k" from your dictionary to navigate easier to delete
          -- Close the buffer under the cursor
          -- NOTE: Make sure you don't use the character below on your dictionary
          close_buffer = "d",
        },
        -- Define the way buffers are sorted by default
        -- Can be any of "default" (sort buffers by their number) or "last" (sort buffers by last accessed)
        -- If you choose "last", it will be modifying sorting the boffers by last
        -- accessed, so the "a" will always be assigned to your latest accessed
        -- buffer
        -- If you want the letters not to change, leave the sorting at default
        sort = "default",
      })
    end,
  },
}
