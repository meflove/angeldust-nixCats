return {
  {
    "nu-lint",
    root_markers = {
      ".git",
    },
    lsp = {
      filetypes = { "nu" },
      cmd = { "nu-lint", "--lsp" },
      settings = {},
    },
  },
}
