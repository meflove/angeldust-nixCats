return {
  {
    "yamlls",
    root_markers = {
      ".git",
    },
    load = function(name)
      -- Load SchemaStore plugin before yamlls configuration
      vim.cmd.packadd("SchemaStore.nvim")
      vim.cmd.packadd(name)
    end,
    lsp = {
      filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
      settings = {
        yaml = {
          format = { enable = true },
          validate = true,
          completion = true,
          schemaStore = {
            enable = false,
            url = "",
          },

          schemas = {},
        },
        redhat = { telemetry = { enabled = false } },
      },
    },
    after = function(_)
      -- Load schemas after plugin is loaded
      local schemastore_ok, schemastore = pcall(require, "schemastore")
      if schemastore_ok then
        vim.lsp.config("yamlls", {
          settings = {
            yaml = {
              schemas = schemastore.yaml.schemas(),
            },
          },
        })
      end
    end,
  },
}
