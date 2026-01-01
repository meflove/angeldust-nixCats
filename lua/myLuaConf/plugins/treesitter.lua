-- [[ Configure Treesitter ]]
-- See `:help nvim-treesitter`
return {
  {
    "nvim-treesitter-context",
    for_cat = "general.treesitter",
    dep_of = { "nvim-treesitter" },
    after = function(plugin)
      require("treesitter-context").setup({
        enable = true,
        max_lines = 5,
      })
    end,
  },
  {
    "nvim-treesitter",
    for_cat = "general.treesitter",
    lazy = false,
    after = function(plugin)
      local ts = require("nvim-treesitter")

      local group = vim.api.nvim_create_augroup("TreesitterSetup", { clear = true })

      local ignore_filetypes = {
        "checkhealth",
        "lazy",
        "mason",
        "snacks_dashboard",
        "snacks_notif",
        "snacks_win",
      }

      -- Auto-install parsers and enable highlighting on FileType
      vim.api.nvim_create_autocmd("FileType", {
        group = group,
        desc = "Enable treesitter highlighting and indentation",
        callback = function(event)
          if vim.tbl_contains(ignore_filetypes, event.match) then
            return
          end

          local lang = vim.treesitter.language.get_lang(event.match) or event.match
          local buf = event.buf

          -- Start highlighting immediately (works if parser exists)
          pcall(vim.treesitter.start, buf, lang)

          -- Enable treesitter indentation
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end,
      })

      ts.setup({
        highlight = { enable = true },
        indent = { enable = true },
        folds = { enable = true },

        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = "<c-space>",
            node_incremental = "<c-space>",
            scope_incremental = "<c-s>",
            node_decremental = "<M-space>",
          },
        },
        textobjects = {
          select = {
            enable = true,
            lookahead = true, -- Automatically jump forward to textobj, similar to targets.vim
            keymaps = {
              -- You can use the capture groups defined in textobjects.scm
              ["aa"] = "@parameter.outer",
              ["ia"] = "@parameter.inner",
              ["af"] = "@function.outer",
              ["if"] = "@function.inner",
              ["ac"] = "@class.outer",
              ["ic"] = "@class.inner",
            },
          },
          move = {
            enable = true,
            set_jumps = true, -- whether to set jumps in the jumplist
            goto_next_start = {
              ["]m"] = "@function.outer",
              ["]]"] = "@class.outer",
            },
            goto_next_end = {
              ["]M"] = "@function.outer",
              ["]["] = "@class.outer",
            },
            goto_previous_start = {
              ["[m"] = "@function.outer",
              ["[["] = "@class.outer",
            },
            goto_previous_end = {
              ["[M"] = "@function.outer",
              ["[]"] = "@class.outer",
            },
          },
          swap = {
            enable = true,
            swap_next = {
              ["<leader>a"] = "@parameter.inner",
            },
            swap_previous = {
              ["<leader>A"] = "@parameter.inner",
            },
          },
        },
      })
    end,
  },
}
