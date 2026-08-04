local load_w_after = function(name)
  vim.cmd.packadd(name)
  vim.cmd.packadd(name .. "/after")
end

return {
  {
    "learning",
    for_cat = "general.completion",
    after = function(_)
      require("learning").setup({
        provider = {
          api_url = "https://openrouter.ai/api/v1/chat/completions",
          api_key = os.getenv("OPENROUTER_API_KEY"),
          model = nixCats.extra("ai.model"),
        },
      })
    end,
  },
  {
    "cmp-cmdline",
    for_cat = "general.completion",
    on_plugin = { "blink.cmp" },
    load = load_w_after,
  },
  {
    "blink.compat",
    for_cat = "general.completion",
    dep_of = { "cmp-cmdline" },
  },
  {
    "luasnip",
    for_cat = "general.completion",
    dep_of = { "blink.cmp" },
    after = function(_)
      local ls = require("luasnip")
      local types = require("luasnip.util.types")

      ls.setup({
        -- Allow jumping back to a previous tab-stop with <S-Tab>.
        history = true,
        -- Re-evaluate function/dynamic nodes as you type (powers the `up` snippet).
        update_events = "TextChanged,TextChangedI",
        delete_check_events = "TextChanged",
        ext_opts = {
          [types.choiceNode] = {
            active = {
              virt_text = { { "● choiceNode — cycle with <C-l>", "Comment" } },
            },
          },
        },
      })

      -- Load lua-format snippets from `lua/snippets/<ft>.lua`.
      -- The path is resolved from the runtimepath, so it works in both nix and
      -- non-nix mode. lazy_load only pulls a filetype's snippets when a buffer
      -- of that type is opened. See :h luasnip-loaders-lua.
      local snippet_paths = vim.api.nvim_get_runtime_file("lua/snippets", true)
      if #snippet_paths > 0 then
        require("luasnip.loaders.from_lua").lazy_load({ paths = snippet_paths })
      end

      -- Cycle choice nodes (e.g. the `if`/`class` snippets). blink.cmp's
      -- super-tab preset already handles <Tab>/<S-Tab> snippet jumping, so we
      -- only add choice cycling here. Only active while inside a snippet.
      vim.keymap.set({ "i", "s" }, "<C-l>", function()
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end, { silent = true, desc = "LuaSnip: next choice node" })
      vim.keymap.set({ "i", "s" }, "<C-h>", function()
        if ls.choice_active() then
          ls.change_choice(-1)
        end
      end, { silent = true, desc = "LuaSnip: previous choice node" })
    end,
  },
  -- {
  --   "blink-copilot",
  --   for_cat = "general.completion",
  --   on_plugin = { "blink.cmp" },
  -- },
  -- {
  --   "copilot.lua",
  --   for_cat = "general.completion",
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
  -- NOTE: Alternative to Copilot - uncomment when reaching Copilot limits
  -- Switch between copilot.lua and windsurf.nvim based on which service has available quota
  -- {
  --   "windsurf.nvim",
  --   for_cat = "general.completion",
  --   on_plugin = { "blink.cmp" },
  --   after = function()
  --     require("codeium").setup({
  --       enable_cmp_source = true,
  --       virtual_text = {
  --         enabled = false,
  --         key_bindings = {
  --           accept = false, -- handled by nvim-cmp / blink.cmp
  --           next = "<M-]>",
  --           prev = "<M-[>",
  --         },
  --       },
  --     })
  --   end,
  -- },
  {
    "minuet-ai.nvim",
    for_cat = "general.completion",
    on_plugin = { "blink.cmp" },
    after = function(_)
      require("minuet").setup({
        provider = "openai_compatible",
        request_timeout = 2.5,
        throttle = 1500,
        debounce = 600,
        provider_options = {
          -- openai_compatible = {
          --   api_key = "OPENROUTER_API_KEY",
          --   end_point = "https://openrouter.ai/api/v1/chat/completions",
          --   model = nixCats.extra("ai.model"),
          --   name = "Openrouter",
          --   optional = {
          --     max_tokens = 56,
          --     top_p = 0.9,
          --     provider = {
          --       -- Prioritize throughput for faster completion
          --       sort = "throughput",
          --     },
          --     -- disable thinking to avoid first token latency
          --     reasoning_effort = "none",
          --   },
          -- },
          claude = {
            model = "glm-4.7",
            api_key = "ANTHROPIC_API_KEY",
            end_point = "https://api.z.ai/api/anthropic",
            optional = {
              -- pass any additional parameters you want to send to claude request,
              -- e.g.
              -- stop_sequences = nil,
            },
            -- a list of functions to transform the endpoint, header, and request body
            transform = {},
          },
        },

        virtualtext = {
          show_on_completion_menu = true,
        },
      })
    end,
  },
  {
    "colorful-menu.nvim",
    for_cat = "general.completion",
    on_plugin = { "blink.cmp" },
  },
  {
    "blink.pairs",
    for_cat = "general.completion",
    on_plugin = { "blink.cmp" },
    after = function(_)
      require("blink.pairs").setup({})
    end,
  },
  {
    "blink.cmp",
    for_cat = "general.completion",
    event = "DeferredUIEnter",
    after = function(_)
      require("blink.cmp").setup({
        -- 'default' (recommended) for mappings similar to built-in completions (C-y to accept)
        -- See :h blink-cmp-config-keymap for configuring keymaps
        keymap = {
          preset = "super-tab",
          -- Manually invoke minuet completion.
          ["<A-y>"] = require("minuet").make_blink_map(),
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
        },
        sources = {
          default = { "lsp", "path", "snippets", "buffer", "omni", "minuet" }, -- "copilot" "codeium"
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
            minuet = {
              name = "minuet",
              module = "minuet.blink",
              async = true,
              -- Should match minuet.config.request_timeout * 1000,
              -- since minuet.config.request_timeout is in seconds
              timeout_ms = 7500,
              score_offset = 50, -- Gives minuet higher priority among suggestions
            },
          },
          -- copilot = {
          --   name = "copilot",
          --   module = "blink-copilot",
          --   score_offset = 100,
          --   async = true,
          -- },
          -- codeium = {
          --   name = "Codeium",
          --   module = "codeium.blink",
          --   score_offset = 100,
          --   async = true,
          -- },
        },
      })
    end,
  },
}
