return {
  "lualine.nvim",
  for_cat = "general.always",
  event = "DeferredUIEnter",
  after = function(plugin)
    -- Eviline config for lualine
    -- Author: shadmansaleh
    -- Credit: glepnir
    -- A little bit modified by me :)
    local lualine = require("lualine")

    -- Color table for highlights
    -- stylua: ignore
    local colors = {
      bg       = '#1E2030',
      fg       = '#cad3f5',
      yellow   = '#eed49f',
      cyan     = '#8bd5ca',
      darkblue = '#081633',
      green    = '#a6da95',
      orange   = '#f5a97f',
      violet   = '#f5bde6',
      magenta  = '#c6a0f6',
      blue     = '#8aadf4',
      red      = '#ed8796',
    }

    local conditions = {
      buffer_not_empty = function()
        return vim.fn.empty(vim.fn.expand("%:t")) ~= 1
      end,
      hide_in_width = function()
        return vim.fn.winwidth(0) > 80
      end,
      check_git_workspace = function()
        local filepath = vim.fn.expand("%:p:h")
        local gitdir = vim.fn.finddir(".git", filepath .. ";")
        return gitdir and #gitdir > 0 and #gitdir < #filepath
      end,
    }

    -- Function to get repository name
    local function get_repo_name()
      local git_dir = vim.fn.finddir(".git", vim.fn.expand("%:p:h") .. ";")
      if git_dir == "" then
        return ""
      end

      local git_config = git_dir .. "/config"
      if vim.fn.filereadable(git_config) == 0 then
        return ""
      end

      local config_lines = vim.fn.readfile(git_config)
      for _, line in ipairs(config_lines) do
        local url = line:match("%s+url = .+/(.+).git")
        if url then
          return url
        end
      end

      return ""
    end

    -- Config
    local config = {
      options = {
        -- Disable sections and component separators
        component_separators = "",
        section_separators = "",
        theme = {
          -- We are going to use lualine_c an lualine_x as left and
          -- right section. Both are highlighted by c theme .  So we
          -- are just setting default looks o statusline
          normal = { c = { fg = colors.fg, bg = colors.bg } },
          inactive = { c = { fg = colors.fg, bg = colors.bg } },
        },
      },
      sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        -- These will be filled later
        lualine_c = {},
        lualine_x = {},
      },
      inactive_sections = {
        -- these are to remove the defaults
        lualine_a = {},
        lualine_b = {},
        lualine_y = {},
        lualine_z = {},
        lualine_c = {},
        lualine_x = {},
      },
    }

    -- Inserts a component in lualine_c at left section
    local function ins_left(component)
      table.insert(config.sections.lualine_c, component)
    end

    -- Inserts a component in lualine_x at right section
    local function ins_right(component)
      table.insert(config.sections.lualine_x, component)
    end

    ins_left({
      function()
        return "▊"
      end,
      color = { fg = colors.magenta }, -- Sets highlighting of component
      padding = { left = 0, right = 1 }, -- We don't need space before this
    })

    ins_left({
      -- mode component
      function()
        return ""
      end,
      color = function()
        -- auto change color according to neovims mode
        local mode_color = {
          n = colors.red,
          i = colors.green,
          v = colors.blue,
          [""] = colors.blue,
          V = colors.blue,
          c = colors.magenta,
          no = colors.red,
          s = colors.orange,
          S = colors.orange,
          [""] = colors.orange,
          ic = colors.yellow,
          R = colors.violet,
          Rv = colors.violet,
          cv = colors.red,
          ce = colors.red,
          r = colors.cyan,
          rm = colors.cyan,
          ["r?"] = colors.cyan,
          ["!"] = colors.red,
          t = colors.red,
        }
        return { fg = mode_color[vim.fn.mode()] }
      end,
      padding = { right = 1 },
    })

    ins_left({
      -- filesize component
      "filesize",
      cond = conditions.buffer_not_empty,
    })

    ins_left({
      function()
        local filename = vim.fn.expand("%:t")
        if filename == "" then
          return ""
        end

        local icon = ""
        if package.loaded["mini.icons"] then
          local ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
          local icon_data = require("mini.icons").get("filetype", ft)
          icon = icon_data .. " "
        end

        local pinned = function()
          local cur_buf = vim.api.nvim_get_current_buf()
          return require("hbac.state").is_pinned(cur_buf) and " " or ""
          -- tip: nerd fonts have pinned/unpinned icons!
        end

        return icon .. filename .. pinned()
      end,
      cond = conditions.buffer_not_empty,
      color = { fg = colors.magenta, gui = "bold" },
    })

    ins_left({ "location" })

    ins_left({ "progress", color = { fg = colors.fg, gui = "bold" } })

    ins_left({
      "diagnostics",
      sources = { "nvim_diagnostic" },
      symbols = { error = " ", warn = " ", info = " " },
      diagnostics_color = {
        error = { fg = colors.red },
        warn = { fg = colors.yellow },
        info = { fg = colors.cyan },
      },
    })

    -- Insert mid section. You can make any number of sections in neovim :)
    -- for lualine it's any number greater then 2
    ins_left({
      function()
        return "%="
      end,
    })

    ins_left({
      -- Lsp server name .
      function()
        local buf_ft = vim.api.nvim_get_option_value("filetype", { buf = 0 })
        local buf_clients = vim.lsp.get_clients({ bufnr = 0 })

        if #buf_clients == 0 then
          return "No Active Lsp"
        end

        local lsp_names = {}
        local colors = {
          colors.cyan, -- #8bd5ca
          colors.magenta, -- #f5bde6
          colors.blue, -- #8aadf4
          colors.green, -- #a6da95
          colors.yellow, -- #eed49f
          colors.orange, -- #f5a97f
          colors.red, -- #ed8796
          colors.violet, -- #c6a0f6
        }

        -- Filter clients that support current filetype
        local active_clients = {}
        for _, client in ipairs(buf_clients) do
          local filetypes = client.config.filetypes
          -- Exclude copilot from LSP list
          if client.name ~= "copilot" and (not filetypes or vim.fn.index(filetypes, buf_ft) ~= -1) then
            table.insert(active_clients, client)
          end
        end

        if #active_clients == 0 then
          return "No Active Lsp"
        end

        -- Create colored LSP names
        for i, client in ipairs(active_clients) do
          local color = colors[(i - 1) % #colors + 1]
          local name = client.name

          -- Create highlight group for this LSP
          local hl_group = "LualineLSP" .. i
          vim.api.nvim_set_hl(0, hl_group, { fg = color, bold = true })

          -- Format with highlight
          local formatted = string.format("%%#%s#%s%%*", hl_group, name)
          table.insert(lsp_names, formatted)
        end

        return table.concat(lsp_names, " • ")
      end,
      icon = " LSP:",
      color = { fg = "#ffffff", gui = "bold" },
    })

    -- Noice command/mode display
    ins_right({
      function()
        if package.loaded["noice"] then
          return require("noice").api.status.command.get()
        end
        return ""
      end,
      cond = function()
        return package.loaded["noice"] and require("noice").api.status.command.has()
      end,
      color = { fg = colors.fg },
    })

    -- Macro recording status
    ins_right({
      function()
        local reg = vim.fn.reg_recording()
        if reg == "" then
          return ""
        end
        return "recording @" .. reg
      end,
      color = { fg = colors.red, gui = "bold" },
    })

    -- Add components to right sections
    ins_right({
      "o:encoding", -- option component same as &encoding in viml
      fmt = string.upper, -- I'm not sure why it's upper case either ;)
      cond = conditions.hide_in_width,
      color = { fg = colors.green, gui = "bold" },
    })

    ins_right({
      "fileformat",
      -- fmt = string.find,
      icons_enabled = true, -- I think icons are cool but Eviline doesn't have them. sigh
      color = { fg = colors.green, gui = "bold" },
    })

    ins_right({
      -- Repo name component
      function()
        return get_repo_name()
      end,
      icon = "󰊢",
      color = { fg = colors.cyan, gui = "bold" },
      cond = conditions.check_git_workspace,
    })

    ins_right({
      "branch",
      icon = "",
      color = { fg = colors.violet, gui = "bold" },
    })

    ins_right({
      "diff",
      -- Is it me or the symbol for modified us really weird
      symbols = { added = " ", modified = " ", removed = " " },
      diff_color = {
        added = { fg = colors.green },
        modified = { fg = colors.orange },
        removed = { fg = colors.red },
      },
      cond = conditions.hide_in_width,
    })

    ins_right({
      function()
        return "▊"
      end,
      color = { fg = colors.magenta },
      padding = { left = 1 },
    })

    -- Now don't forget to initialize lualine
    lualine.setup(config)
  end,
}
