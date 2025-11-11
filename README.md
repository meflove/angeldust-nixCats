# 🐱 nixCats Neovim Configuration

A comprehensive Neovim configuration managed with **nixCats** - a Nix-based package manager for Neovim plugins and configuration. This setup provides a reproducible, declarative Neovim environment with support for multiple programming languages, modern plugins, and powerful development tools.

## ✨ Features

### 🎨 User Interface
- **Catppuccin Theme** - Beautiful, modern color scheme
- **Noice.nvim** - Enhanced UI for notifications, cmdline, and messages
- **Tiny Inline Diagnostic** - Clean inline diagnostics display
- **Indent Blankline** - Visual indentation guides
- **Snacks Explorer** - Modern file explorer sidebar

### 🔧 Code Editing
- **Blink.cmp** - Fast, modern completion engine
- **Copilot.lua** - GitHub Copilot integration for AI assistance
- **Treesitter** - Advanced syntax highlighting and code understanding
- **Flash.nvim** - Quick navigation and search

### 🧠 LSP & IntelliSense
- **Multi-language support** with dedicated LSP configurations:
  - **Python**: PylSP with Ruff formatter/linter, BasedPyright for type checking
  - **Lua**: LuaLS for intelligent Lua development
  - **Nix**: NixLSP for Nix file editing
  - **Bash**: BashLS for shell script development
  - **Markdown**: Marksman for markdown editing and markview.nvim for preview
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
├── flake.nix              # Main Nix flake with dependencies and configuration
├── devenv.nix             # Development environment setup
├── init.lua               # Main Neovim entry point
├── lua/
│   └── myLuaConf/
│       ├── init.lua       # Main configuration loader
│       ├── LSPs/          # LSP configurations
│       │   ├── init.lua   # LSP setup
│       │   └── languages/ # Language-specific LSP configs
│       ├── plugins/       # Plugin specifications
│       └── *.lua          # Other configuration modules
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
    inputs.nixpkgs.follows = "nixpkgs";
  };
  ```

2. **Add package to environment.systemPackages or home.packages:**
  ```bash
  home.packages = with pkgs; [
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

- **Catppuccin** theme (mocha/latte/frappe/macchiato variants)
- **Custom highlight groups** for better readability
- **Transparent background** support for terminal integration
- **Integrated statusline** with Git information

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
