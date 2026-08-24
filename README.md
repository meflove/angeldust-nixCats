> [!IMPORTANT]
> ⚠️ **This repository is now in maintenance mode.**
> I have moved to a new setup: **[angeldust-nvimWrap](https://github.com/meflove/angeldust-nvimWrap)** — please use that going forward.
> Only critical fixes will be applied here.

# 🐱 nixCats Neovim Configuration

A comprehensive Neovim configuration managed with **nixCats** - a Nix-based package manager for Neovim plugins and configuration. This setup provides a reproducible, declarative Neovim environment with support for multiple programming languages, modern plugins, and powerful development tools.

<!--toc:start-->

- [🐱 nixCats Neovim Configuration](#🐱-nixcats-neovim-configuration)
  - [✨ Features](#features)
    - [🎨 User Interface](#🎨-user-interface)
    - [🔧 Code Editing](#🔧-code-editing)
    - [🧠 LSP & IntelliSense](#🧠-lsp-intellisense)
    - [🛠️ Development Tools](#🛠️-development-tools)
  - [🏗️ Architecture](#🏗️-architecture)
  - [📁 Project Structure](#📁-project-structure)
  - [🚀 Getting Started](#🚀-getting-started)
    - [Prerequisites](#prerequisites)
    - [Installation](#installation)
    - [Available Build Outputs](#available-build-outputs)
  - [🎯 Supported Languages](#🎯-supported-languages)
    - [Primary Support](#primary-support)
    - [Extended Features](#extended-features)
  - [⚙️ Customization](#️-customization)
    - [Adding New Plugins](#adding-new-plugins)
    - [Enabling/Disabling Features](#enablingdisabling-features)
    - [Language Configuration](#language-configuration)
  - [🔧 Development Environment](#🔧-development-environment)
  - [🎨 Theme & Appearance](#🎨-theme-appearance)
  - [📚 Documentation](#📚-documentation)
  - [🤝 Contributing](#🤝-contributing)
  - [📄 License](#📄-license)
  <!--toc:end-->

## ✨ Features

### 🎨 User Interface

- **rose-pine** - Beautiful, modern color scheme (moon variant)
- **Noice.nvim** - Enhanced UI for notifications, cmdline, and messages
- **Tiny Inline Diagnostic** - Clean inline diagnostics display
- **Indent Blankline** - Visual indentation guides
- **Snacks Explorer** - Modern file explorer sidebar

### 🔧 Code Editing

- **Blink.cmp** - Fast, modern completion engine
- **minuet-ai.nvim** - AI completion via OpenRouter (configurable model)
- **Treesitter** - Advanced syntax highlighting and code understanding
- **Flash.nvim** - Quick navigation and search

### 🧠 LSP & IntelliSense

- **Multi-language support** with dedicated LSP configurations:
  - **Python**: PylSP with Ruff formatter/linter, BasedPyright for type checking
  - **Lua**: LuaLS for intelligent Lua development
  - **Nix**: NixLSP for Nix file editing
  - **Bash**: BashLS for shell script development
  - **Markdown**: Marksman for markdown editing and markview.nvim for preview
  - **Rust**: Rust Analyzer for Rust development
- **LSP Config** - Seamless LSP integration

### 🛠️ Development Tools

- **Git Integration**: Git signs, git blame, git UI components
- **Snacks Picker**: Powerful fuzzy finder and picker
- **Which-key**: Keyboard shortcut discovery
- **ts-comments.nvim**: Smart commenting utilities
- **Blink.pairs**: Automatic bracket/quote pairing
- **Gitsigns**: Git status indicators in the editor

## 🏗️ Architecture

This configuration uses the **idiomatic nixCats approach**:

- **No lazy.nvim** - Plugin management handled entirely by Nix
- **No mason.nvim** - All LSPs and tools managed via Nix packages
- **Category-based loading** - Features enabled/disabled via Nix categories
- **lze for lazy loading** - Efficient plugin loading when needed
- **Modular structure** - Configuration split across organized files

## 📁 Project Structure

```
.
├── flake.nix              # Main Nix flake: inputs, categories, package definitions
├── devenv.nix             # devenv shell + pre-commit hooks (lint/format)
├── init.lua               # Neovim entry point (bootstraps nixCats mock + config)
├── stylua.toml            # StyLua formatter config
├── after/
│   └── queries/nix/       # Treesitter injections for Nix (bash/fish/python/…)
├── lua/
│   ├── nixCatsUtils/      # nixCats helpers (mock setup, lze `for_cat` handler)
│   ├── snippets/          # LuaSnip snippets (lua / nix / python)
│   └── myLuaConf/
│       ├── init.lua       # Main configuration loader
│       ├── opts_and_keys.lua  # Vim options + keymaps
│       ├── format.lua     # conform.nvim setup
│       ├── lint.lua       # nvim-lint setup
│       ├── LSPs/          # LSP configurations
│       │   ├── init.lua   # LSP loader + per-language imports
│       │   └── languages/ # Language-specific LSP configs
│       └── plugins/       # Plugin specs (completion/editor/git/ui/…)
├── .github/workflows/     # CI: cachix push, flake-lock update, codeberg mirror
└── README.md              # This file
```

## 🚀 Getting Started

### Prerequisites

- **NixOS** or **Nix Package Manager** with flakes enabled
- **Git** for version control

### Installation

1. **Add repo to flake inputs:**

```bash
angeldust-nixCats = {
  url = "github:meflove/angeldust-nixCats";
};
```

2. **Add package to environment.systemPackages or home.packages:**

```bash
home.packages = [
  inputs.angeldust-nixCats.packages.${pkgs.stdenv.hostPlatform.system}.default
];
```

3. **Rebuild your system:**

```bash
sudo nixos-rebuild switch --flake .
# or
home-manager switch --flake .
```

4. **Open editor:**

```bash
nixCats
# or
vim
# or
vimcat
```

### Available Build Outputs

Check available packages with:

```bash
nix flake show
```

Typical outputs include:

- `nixCats` - Main Neovim with all plugins
- `defaultPackage` - Default Neovim configuration
- `devShell` - Development environment with linting tools

## 🎯 Supported Languages

### Primary Support

- **Python** 🐍 - Full LSP, formatting (Ruff), linting, type checking
- **Lua** 🌙 - Complete LSP support for Neovim development
- **Nix** ❄️ - Nix language server integration
- **Bash** 🐚 - Shell script LSP support
- **Rust** 🦀 - rust-analyzer LSP with rustaceanvim, bacon-ls for background checking, crates.nvim for dependency management

### Extended Features

- **Markdown** 📝 - Enhanced editing with preview support
- **Configuration Files** - Support for various config formats

## ⚙️ Customization

### Adding New Plugins

Add plugins to `flake.nix` inputs section:

```nix
"plugins-your-plugin" = {
  url = "github:user/repo";
  flake = false;
};
```

Then configure in the appropriate Lua file using `lze` specifications.

### Enabling/Disabling Features

Edit the category definitions in `flake.nix` to enable/disable features:

- `debug` - Debug tools and configurations
- `lint` - Linting support
- `format` - Code formatting
- Custom categories for different plugin groups

### Language Configuration

Add new language LSPs in `lua/myLuaConf/LSPs/languages/` and import them in `lua/myLuaConf/LSPs/init.lua`.

## 🔧 Development Environment

This project includes a comprehensive development environment with:

- **Pre-commit hooks** for code quality
- **Linting** with `alejandra` (Nix formatting) and `statix`
- **Shell checking** for shell scripts
- **Git hooks** for automated quality checks

Activate with:

```bash
direnv allow
```

## 🎨 Theme & Appearance

- **rose-pine** theme (moon variant, configurable via `categories.colorscheme` in `flake.nix`)
- **Custom highlight groups** for better readability
- **Integrated statusline** (lualine) with Git information and LSP status

## 📚 Documentation

- **nixCats Documentation**: [https://nixcats.org](https://nixcats.org)
- **Plugin Documentation**: Individual plugin docs linked in configurations
- **Lua Configuration**: Extensive inline comments throughout Lua files
- **Lazy Loading**: `lze` plugin loading documentation for advanced usage

## 🤝 Contributing

This is a personal configuration, but feel free to:

- Fork and adapt for your needs
- Submit issues for bugs or improvements
- Share suggestions for optimizations

## 📄 License

Based on nixCats example configuration - licensed under MIT License.

---

**Built with ❤️ using nixCats, Nix, and Neovim**
