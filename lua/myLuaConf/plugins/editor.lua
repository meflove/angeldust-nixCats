return {
  {
    "ts-comments.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("ts-comments").setup({})
    end,
  },
  {
    "flash.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump()
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Treesitter Search",
      },
      {
        "<C-x>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
      -- Simulate nvim-treesitter incremental selection
      {
        "<c-space>",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter({
            actions = {
              ["<c-space>"] = "next",
              ["<BS>"] = "prev",
            },
          })
        end,
        desc = "Treesitter Incremental Selection",
      },
    },
    after = function(plugin)
      require("flash").setup()
    end,
  },
  {
    "which-key.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("which-key").setup({})
      require("which-key").add({
        { "<leader><leader>_", hidden = true },
        { "<leader>c", group = "[c]ode" },
        { "<leader>c_", hidden = true },
        { "<leader>d", group = "[d]ocument" },
        { "<leader>d_", hidden = true },
        { "<leader>g", group = "[g]it" },
        { "<leader>g_", hidden = true },
        { "<leader>m", group = "[m]arkdown" },
        { "<leader>m_", hidden = true },
        { "<leader>r", group = "[r]ename" },
        { "<leader>r_", hidden = true },
        { "<leader>s", group = "[s]earch" },
        { "<leader>s_", hidden = true },
        { "<leader>t", group = "[t]oggles" },
        { "<leader>t_", hidden = true },
        { "<leader>w", group = "[w]orkspace" },
        { "<leader>w_", hidden = true },
      })
    end,
  },
  {
    "hover.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    keys = {
      {
        "K",
        function()
          require("hover").open()
        end,
        desc = "Hover",
      },
    },
    after = function(plugin)
      require("hover").config({
        preview_window = true,
      })
    end,
  },
}
