return {
  {
    "jsonls",
    root_markers = {
      ".git",
    },
    lsp = {
      filetypes = { "json" },
      settings = {
        jsonls = {
          format = { enable = true },
          validate = { enable = true },

          schemas = {},
        },
      },
    },
    after = function(_)
      -- Load schemas after plugin is loaded
      local schemastore_ok, schemastore = pcall(require, "schemastore")
      if schemastore_ok then
        vim.lsp.config("jsonls", {
          settings = {
            jsonls = {
              schemas = schemastore.json.schemas(),
            },
          },
        })
      end
    end,
  },
}
