return {
  {
    "pylsp",
    root_markers = {
      "pyproject.toml",
      "setup.py",
      "setup.cfg",
      "requirements.txt",
      "Pipfile",
      "pyrightconfig.json",
      ".git",
      "ruff.toml",
    },
    lsp = {
      filetypes = { "python" },
      settings = {
        pylsp = {
          signatue = {
            formatter = "ruff",
          },
          plugins = {
            ruff = {
              enabled = true, -- Enable the plugin
              cmd_env = { RUFF_TRACE = "messages" },
              init_options = {
                settings = {
                  logLevel = "info",
                  configurationPreference = "filesystemFirst",
                  lint = {
                    preview = true,
                  },
                  format = {
                    preview = true,
                  },
                  configuration = {
                    format = {
                      ["quote-style"] = "single",
                    },
                  },
                },
              },
              formatEnabled = true, -- Enable formatting using ruffs formatter
              executable = "ruff", -- Custom path to ruff
              preview = true, -- Whether to enable the preview style linting and formatting.
              targetVersion = "py313", -- The minimum python version to target (applies for both linting and formatting).
            },
            rope_autoimport = { enabled = true },
            pyflakes = { enabled = false },
            flake8 = { enabled = false },
            pylint = { enabled = false },
            mccabe = { enabled = false },
            autopep8 = { enabled = false },
            jedi = { enabled = false },
            preload = { enabled = false },
            pycodestyle = { enabled = false },
            yapf = { enabled = false },
          },
        },
      },
    },
  },
  {
    "basedpyright",
    lsp = {
      filetypes = { "python" },
      root_markers = {
        "pyproject.toml",
        "setup.py",
        "setup.cfg",
        "requirements.txt",
        "Pipfile",
        "pyrightconfig.json",
        ".git",
      },
      settings = {
        basedpyright = {
          disableOrganizeImports = true,
          analysis = {
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            diagnosticMode = "openFilesOnly",
          },
        },
      },
    },
  },
}
