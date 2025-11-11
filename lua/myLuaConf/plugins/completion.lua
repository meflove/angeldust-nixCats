local load_w_after = function(name)
  vim.cmd.packadd(name)
  vim.cmd.packadd(name .. "/after")
end

return {
  {
    "cmp-cmdline",
    for_cat = "general.blink",
    on_plugin = { "blink.cmp" },
    load = load_w_after,
  },
  {
    "blink.compat",
    for_cat = "general.blink",
    dep_of = { "cmp-cmdline" },
  },
  {
    "luasnip",
    for_cat = "general.blink",
    dep_of = { "blink.cmp" },
    after = function(_)
      local luasnip = require("luasnip")
      require("luasnip.loaders.from_vscode").lazy_load()
      luasnip.config.setup({})

      local ls = require("luasnip")

      vim.keymap.set({ "i", "s" }, "<M-b>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end)
    end,
  },
  -- {
  --   "blink-copilot",
  --   for_cat = "general.blink",
  --   on_plugin = { "blink.cmp" },
  -- },
  -- {
  --   "copilot.lua",
  --   for_cat = "general.blink",
  --   dep_of = { "blink-copilot" },
  --   after = function(_)
  --     require("copilot").setup({
  --       suggestion = { enabled = false },
  --       panel = { enabled = false },
  --       filetypes = {
  --         markdown = true,
  --         help = true,
  --       },
  --     })
  --   end,
  -- },
  {
    "windsurf.nvim",
    for_cat = "general.blink",
    on_plugin = { "blink.cmp" },
    after = function()
      require("codeium").setup({
        enable_cmp_source = true,
        virtual_text = {
          enabled = false,
          key_bindings = {
            accept = false, -- handled by nvim-cmp / blink.cmp
            next = "<M-]>",
            prev = "<M-[>",
          },
        },
      })
    end,
  },
  {
    "colorful-menu.nvim",
    for_cat = "general.blink",
    on_plugin = { "blink.cmp" },
  },
  {
    "blink.pairs",
    for_cat = "general.blink",
    on_plugin = { "blink.cmp" },
    after = function(_)
      require("blink.pairs").setup({})
    end,
  },
  {
    "blink.cmp",
    for_cat = "general.blink",
    event = "DeferredUIEnter",
    after = function(_)
      require("blink.cmp").setup({
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- See :h blink-cmp-config-keymap for configuring keymaps
        keymap = {
          preset = "super-tab",
        },
        fuzzy = {
          implementation = "prefer_rust_with_warning",
          sorts = {
            "exact",
            -- defaults
            "score",
            "sort_text",
          },
        },

        cmdline = {
          enabled = true,
          completion = {
            menu = {
              auto_show = true,
            },
          },
          sources = function()
            local type = vim.fn.getcmdtype()
            -- Search forward and backward
            if type == "/" or type == "?" then
              return { "buffer" }
            end
            -- Commands
            if type == ":" or type == "@" then
              return { "cmdline", "cmp_cmdline" }
            end
            return {}
          end,
        },

        signature = {
          enabled = true,
          window = {
            show_documentation = true,
          },
        },
        completion = {
          ghost_text = { enabled = true, show_with_menu = true },
          accept = {
            create_undo_point = true,
            auto_brackets = {
              enabled = true,
              default_brackets = { "(", ")" },
              kind_resolution = {
                enabled = true,
                blocked_filetypes = { "typescriptreact", "javascriptreact", "vue" },
              },
            },
          },

          documentation = {
            auto_show = true,
            auto_show_delay_ms = 200,
          },

          menu = {
            draw = {
              treesitter = { "lsp" },
              components = {
                label = {
                  text = function(ctx)
                    return require("colorful-menu").blink_components_text(ctx)
                  end,
                  highlight = function(ctx)
                    return require("colorful-menu").blink_components_highlight(ctx)
                  end,
                },
              },
            },
          },
        },
        snippets = {
          preset = "luasnip",
          active = function(filter)
            local snippet = require("luasnip")
            local blink = require("blink.cmp")
            if snippet.in_snippet() and not blink.is_visible() then
              return true
            else
              if not snippet.in_snippet() and vim.fn.mode() == "n" then
                snippet.unlink_current()
              end
              return false
            end
          end,
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "omni", "codeium" }, --, "copilot"
          providers = {
            path = {
              score_offset = 50,
            },
            lsp = {
              score_offset = 40,
            },
            snippets = {
              score_offset = 40,
            },
            cmp_cmdline = {
              name = "cmp_cmdline",
              module = "blink.compat.source",
              score_offset = -100,
              opts = {
                cmp_name = "cmdline",
              },
            },
            codeium = {
              name = "Codeium",
              module = "codeium.blink",
              score_offset = 100,
              async = true,
            },
            -- copilot = {
            --   name = "copilot",
            --   module = "blink-copilot",
            --   score_offset = 100,
            --   async = true,
            -- },
          },
        },
      })
    end,
  },
}
