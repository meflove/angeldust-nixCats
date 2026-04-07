return {
  {
    "tiny-inline-diagnostic",
    for_cat = "general.utilities",
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
    "bafa",
    for_cat = "general.utilities",
    keys = {
      {
        "gb",
        function()
          require("bafa.ui").toggle()
        end,
        desc = "List open buffers",
        noremap = true,
      },
    },
    after = function(plugin)
      require("bafa").setup({
        notify = {
          provider = "vim.notify",
        },
        style = "minimal",
        ui = {
          jump_labels = {
            keys = {
              "a",
              "s",
              "d",
              "f",
              "j",
              "k",
              "l",
              ";",
              "q",
              "w",
              "e",
              "r",
              "u",
              "i",
              "o",
              "p",
              "z",
              "x",
              "c",
              "n",
              "m",
              ",",
              ".",
            },
          },
        },
        diagnostics = true,
      })
    end,
  },
  {
    "kikao",
    for_cat = "general.utilities",
    after = function(plugin)
      require("kikao").setup({
        session_file_name = nil,
      })
    end,
  },
  {
    "hbac",
    for_cat = "general.utilities",
    after = function(plugin)
      require("hbac").setup({
        autoclose = true, -- set autoclose to false if you want to close manually
        threshold = 10, -- hbac will start closing unedited buffers once that number is reached
        close_command = function(bufnr)
          vim.api.nvim_buf_delete(bufnr, {})
        end,
        close_buffers_with_windows = false, -- hbac will close buffers with associated windows if this option is `true`
      })
    end,
  },
  {
    "delta-lua",
    for_cat = "general.utilities",
  },
  {
    "deltaview",
    for_cat = "general.utilities",
    keys = {
      { "<leader>dm", "<cmd>DeltaMenu <CR>", mode = { "n" }, noremap = true, desc = "DeltaMenu" },
      { "<leader>dl", "<cmd>DeltaView <CR>", mode = { "n" }, noremap = true, desc = "DeltaView" },
      { "<leader>da", "<cmd>Delta <CR>", mode = { "n" }, noremap = true, desc = "Delta" },
    },
    after = function(plugin)
      require("deltaview").setup({
        fzf_picker = nil,
        keyconfig = {
          -- Global keybind to toggle DeltaMenu
          dm_toggle_keybind = "<leader>dm",

          -- Global keybind to toggle DeltaView (and exit diff if open)
          dv_toggle_keybind = "<leader>dl",

          -- Global keybind to toggle Delta (and exit diff if open)
          d_toggle_keybind = "<leader>da",

          -- Navigate between hunks in a diff
          next_hunk = "<Tab>",
          prev_hunk = "<S-Tab>",

          -- Navigate between files (when opened from DeltaMenu)
          next_diff = "]f",
          prev_diff = "[f",

          -- Change diff menu view to quickselect (when in fzf picker. This functionality is not available for fzf-lua and telescope)
          fzf_toggle = "alt-;",

          -- Open help legend
          help_legend = "d?",
        },
      })
    end,
  },
}
