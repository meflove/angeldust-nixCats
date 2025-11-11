return {
  {
    "catppuccin-nvim",
    for_cat = "general.extra",
    after = function(plugin)
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
      vim.cmd.colorscheme("catppuccin")
    end,
  },
  {
    "mini.icons",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("mini.icons").setup()
    end,
  },
  {
    "indent-blankline.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    after = function(plugin)
      require("ibl").setup()
    end,
  },
  {
    "snacks.nvim",
    for_cat = "general.extra",
    lazy = false,
    keys = {
      {
        "<leader>.",
        function()
          Snacks.scratch()
        end,
        desc = "Toggle Scratch Buffer",
      },
      {
        "<leader>e",
        function()
          Snacks.explorer()
        end,
        desc = "Toggle Snacks Explorer",
      },
      {
        "<leader>sf",
        function()
          Snacks.picker.smart()
        end,
        desc = "Smart Find Files",
      },
      {
        "<leader>/",
        function()
          Snacks.picker.grep()
        end,
        desc = "Grep",
      },
      {
        "<leader>ss",
        function()
          Snacks.picker.lsp_symbols()
        end,
        desc = "LSP Symbols",
      },
      {
        "<leader>q",
        function()
          Snacks.picker.qflist()
        end,
        desc = "Quickfix List",
      },
      {
        "<leader>su",
        function()
          Snacks.picker.undo()
        end,
        desc = "Undo History",
      },
    },
    after = function(plugin)
      require("snacks").setup({
        scroll = {
          enable = true,
        },
        scratch = {
          enable = true,
        },
        quickfile = {
          enable = true,
        },
        notifier = {
          enable = true,
        },
        explorer = {
          enable = true,
          replace_netrw = true,
          follow_file = false,
        },
        indent = {
          enable = true,
        },
        profiler = {},
        picker = {
          files = { show_hidden = true, ignored = true },
          sources = {
            explorer = {
              layout = { preview = "picker" },
            },
          },
        },
      })

      -- notify LSP progress
      ---@type table<number, {token:lsp.ProgressToken, msg:string, done:boolean}[]>
      local progress = vim.defaulttable()
      vim.api.nvim_create_autocmd("LspProgress", {
        ---@param ev {data: {client_id: integer, params: lsp.ProgressParams}}
        callback = function(ev)
          local client = vim.lsp.get_client_by_id(ev.data.client_id)
          local value = ev.data.params.value --[[@as {percentage?: number, title?: string, message?: string, kind: "begin" | "report" | "end"}]]
          if not client or type(value) ~= "table" then
            return
          end
          local p = progress[client.id]

          for i = 1, #p + 1 do
            if i == #p + 1 or p[i].token == ev.data.params.token then
              p[i] = {
                token = ev.data.params.token,
                msg = ("[%3d%%] %s%s"):format(
                  value.kind == "end" and 100 or value.percentage or 100,
                  value.title or "",
                  value.message and (" **%s**"):format(value.message) or ""
                ),
                done = value.kind == "end",
              }
              break
            end
          end

          local msg = {} ---@type string[]
          progress[client.id] = vim.tbl_filter(function(v)
            return table.insert(msg, v.msg) or not v.done
          end, p)

          local spinner = { "⠋", "⠙", "⠹", "⠸", "⠼", "⠴", "⠦", "⠧", "⠇", "⠏" }
          vim.notify(table.concat(msg, "\n"), "info", {
            id = "lsp_progress",
            title = client.name,
            opts = function(notif)
              notif.icon = #progress[client.id] == 0 and " "
                or spinner[math.floor(vim.uv.hrtime() / (1e6 * 80)) % #spinner + 1]
            end,
          })
        end,
      })
    end,
  },
  {
    "noice.nvim",
    for_cat = "general.extra",
    event = "DeferredUIEnter",
    load = function(name)
      vim.cmd.packadd(name)
      vim.cmd.packadd("notify")
    end,
    after = function(plugin)
      require("noice").setup({
        lsp = {
          progress = {
            enabled = false,
          },
          override = {
            ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
            ["vim.lsp.util.stylize_markdown"] = true,
            ["cmp.entry.get_documentation"] = true,
          },
        },
        routes = {
          {
            filter = {
              event = "msg_show",
              any = {
                { find = "%d+L, %d+B" },
                { find = "; after #%d+" },
                { find = "; before #%d+" },
              },
            },
            view = "mini",
          },
        },
        presets = {
          bottom_search = true,
          command_palette = true,
          long_message_to_split = true,
        },
        notify = {
          enabled = false,
        },
        cmdline = {
          enabled = true,
        },
      })
    end,
  },
}
