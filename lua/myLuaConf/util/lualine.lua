local M = {}

-- Icons configuration to replace LazyVim.config.icons
M.icons = {
  diagnostics = {
    Error = "",
    Warn = "",
    Hint = "",
    Info = "",
  },
  git = {
    added = "",
    modified = "",
    removed = "",
  },
  kinds = {
    Copilot = "",
  },
}

-- Get color from highlight group
M.get_color = function(group)
  local color = vim.api.nvim_get_hl(0, { name = group })
  if color and color.fg then
    return string.format("#%06x", color.fg)
  end
  return nil
end

-- Root directory detection function
M.root_dir = function()
  return function()
    local cwd = vim.fn.getcwd()
    local root = nil

    -- Try to find git root
    local git_root = vim.fn.systemlist("git rev-parse --show-toplevel 2>/dev/null")[1]
    if git_root and git_root ~= "" then
      root = git_root
    else
      root = cwd
    end

    if root then
      local name = vim.fn.fnamemodify(root, ":t")
      if name == "" then
        name = "[No Name]"
      end
      return vim.fn.pathshorten(root)
    end
    return ""
  end
end

-- Pretty path function
M.pretty_path = function()
  return function()
    local path = vim.fn.expand("%:p")
    if path == "" then
      return "[No Name]"
    end

    local cwd = vim.fn.getcwd()
    local home = vim.fn.expand("~")

    -- Replace home with ~
    path = path:gsub("^" .. home:gsub("%W", "%%%1"), "~")

    -- Replace cwd with . if relative
    if path:find("^" .. cwd:gsub("%W", "%%%1")) then
      path = path:gsub("^" .. cwd:gsub("%W", "%%%1") .. "/", "./")
    end

    return path
  end
end

-- Status component helper
M.status = function(icon, fn)
  return function()
    local ok, result = pcall(fn)
    if ok and result then
      return icon .. " " .. result
    end
    return ""
  end
end

-- Check if plugin is loaded
M.has_plugin = function(plugin)
  return package.loaded[plugin] ~= nil
end

return M
