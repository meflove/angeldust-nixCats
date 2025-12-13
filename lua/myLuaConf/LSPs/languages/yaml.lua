return {
  {
    "yamlls",
    root_markers = {
      ".git",
    },
    lsp = {
      filetypes = { "yaml", "yaml.docker-compose", "yaml.gitlab", "yaml.helm-values" },
      settings = {
        yaml = {
          format = { enable = true },
          validate = true,
          completion = true,

          schemas = {
            ["https://json.schemastore.org/github-workflow.json"] = "/.github/workflows/*",
            ["https://garnix.io/api/garnix-config-schema.json"] = "/garnix.yaml",
          },
        },
        redhat = { telemetry = { enabled = false } },
      },
    },
  },
}
