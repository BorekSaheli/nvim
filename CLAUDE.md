# Neovim Configuration Documentation

Personal Neovim configuration featuring a modern plugin setup with lazy loading, LSP support, and extensive customization.

## Core Features

### State Management (`lua/core/state.lua`)

Generic toggle state factory that persists settings across sessions. Manages:

- **Diagnostics Virtual Text**: Toggle LSP diagnostic messages
- **Semantic Tokens**: Toggle semantic highlighting
- **Completion**: Enable/disable autocompletion popup
- **Copilot**: Toggle GitHub Copilot with lazy loading support

All states are persisted to `~/.local/share/nvim/` files.

### Basic Options (`lua/core/options.lua`)

- Leader key: `<Space>`
- Local leader: `\`
- Line numbers: absolute + relative
- Shared clipboard with system
- Swap file warnings suppressed
- Update time: 250ms (faster LSP)
- Which-key timeout: 300ms

### Platform Support

- Cross-platform: Windows, macOS, Linux
- Neovide GUI optimizations (transparency, refresh rate)
- Platform-specific path handling for tools

## Plugin Ecosystem

### Navigation & Search

**Telescope** - Fuzzy finder
- Find files, live grep, buffers, help tags
- Git integration (commits, branches, status)

**Flash** - Quick navigation
- Character-based jumping
- Treesitter integration

**Neo-tree** - File explorer
- Git status integration
- Buffer and filesystem views

### LSP & Language Support

**nvim-lspconfig** - Language servers
- Python: `ty` (type checker) + `ruff` (linter)
- Platform-specific tool path detection
- Automatic root directory detection

**Mason** - LSP installer
- Install language servers, formatters, linters
- UI interface for package management

**Treesitter** - Syntax parsing
- Enhanced syntax highlighting
- Code folding and navigation
- Incremental selection

**nvim-cmp** - Autocompletion
- LSP completions
- Buffer completions
- Path completions
- Snippet support (LuaSnip)
- Toggleable via state system

### Code Quality

**Conform.nvim** - Formatting
- Auto-format on save
- Multiple formatter support
- Language-specific configs

**Trouble** - Diagnostics panel
- Aggregated error/warning list
- Quickfix integration
- LSP references

**Comment.nvim** - Smart commenting
- Language-aware comments
- Toggle line/block comments
- Visual mode support

**guess-indent.nvim** - Indentation detection
- Automatically detects tabs vs spaces
- Detects indent width (2, 4, 8 spaces)
- Respects .editorconfig files
- Manual command: `:GuessIndent`

### Git Integration

**Gitsigns** - Git decorations
- Line blame, diff in sign column
- Hunk navigation and preview
- Stage/unstage hunks

**Lazygit** - Terminal UI for git
- Full git workflow in Neovim
- Floating window integration

### UI & Appearance

**Dashboard** - Startup screen
- Two ASCII art styles (corporate/personal)
- Quick shortcuts (files, grep, lazy, quit)
- Toggleable style: `<leader>ta`

**Lualine** - Status line
- Catppuccin theme integration
- Git branch and diff stats
- LSP diagnostics
- Python virtual environment display
- Toggle indicators (copilot, diagnostics, completion)
- Conditional sections based on window width

**Catppuccin** - Color scheme
- Mocha variant
- Transparent background with custom blue tint
- Integrated with Telescope, Treesitter, LSP, Noice, and Notify

**Noice** - Enhanced UI
- Replaces cmdline, messages, and popupmenu
- Beautiful notifications via nvim-notify
- LSP documentation with Treesitter highlighting
- Message history (`:Noice` command)
- Command palette mode
- Fully integrated with Catppuccin theme

**Indent-blankline** - Indent guides
- Visual indentation markers
- Scope highlighting

### AI & Productivity

**Copilot** - GitHub Copilot
- Lazy-loaded for performance
- Toggle: `<F8>` or via state system
- Persisted on/off state

**Which-key** - Keybinding help
- Auto-popup on leader key
- Buffer-local keymap discovery
- Manual triggers only (no mouse)

## Key Bindings

### Global

| Key | Action |
|-----|--------|
| `<Space><Space>` | Save file |
| `<F5>` | Run current Python file in split |
| `<F8>` | Toggle Copilot |
| `<F9>` | Toggle diagnostics virtual text |
| `<F10>` | Toggle completion popup |
| `<C-d>` | Half page down + center |
| `<C-u>` | Half page up + center |
| `<leader>?` | Show buffer keymaps |

### Toggles

| Key | Action |
|-----|--------|
| `<leader>td` | Toggle diagnostics |
| `<leader>th` | Toggle semantic highlighting |
| `<leader>ta` | Toggle dashboard ASCII art style |

### Dashboard Shortcuts (on startup)

| Key | Action |
|-----|--------|
| `f` | Find files |
| `g` | Live grep |
| `l` | Open Lazy plugin manager |
| `q` | Quit |

### Neovide (GUI only)

- `<D-v>` (Cmd+V): Paste from clipboard in all modes
- Opacity: 0.8
- Refresh rate: 120Hz

## Requirements

### System Dependencies

- Neovim >= 0.9.0 (Noice works best with nightly builds)
- Git
- Ripgrep (for Telescope live_grep)
- Node.js (for some LSP servers)

### Python Tools (LSP)

Install via `uv`:
```bash
uv tool install ty ruff
```

Paths auto-detected:
- Unix: `~/.local/bin/`
- Windows: `~/AppData/Roaming/Python/Scripts/`

### Optional

- Lazygit (for git integration)
- Nerd Font (for icons)
- GitHub Copilot subscription (for AI completions)

## Installation

1. Clone to Neovim config directory:
   ```bash
   git clone <repo-url> ~/.config/nvim
   ```

2. Install Lazy.nvim (auto-bootstraps on first run)

3. Open Neovim:
   ```bash
   nvim
   ```

4. Plugins install automatically via Lazy.nvim

5. Install Python tools:
   ```bash
   uv tool install ty ruff
   ```

6. Install LSP servers via Mason:
   - Open Neovim
   - Run `:Mason`
   - Install desired language servers

## Configuration Philosophy

- **Lazy Loading**: Plugins load on-demand for fast startup
- **Persistent State**: Toggles survive restarts
- **Cross-platform**: Works on Windows, macOS, Linux
- **Minimal Overhead**: Performance-optimized with caching
- **Modular**: Each plugin in separate file
- **Opinionated**: Sensible defaults with easy customization

## Performance Optimizations

- Change detection disabled in Lazy.nvim
- Conditional lualine sections (hide on narrow windows)
- Async Python environment detection
- Cached toggle states
- Event-based plugin loading
- Platform-specific optimizations (Windows fsync disabled)

## Troubleshooting

**Copilot not working**: Ensure you've authenticated:
```vim
:Copilot setup
```

**LSP not starting**: Check tool installation:
```vim
:checkhealth
```

**Slow startup**: Check Lazy plugin stats:
```vim
:Lazy profile
```

**Windows EPERM errors**: Netrw disabled by default for Windows

## Future Enhancements

This configuration is stable but extensible. To add plugins:

1. Create new file in `lua/plugins/`
2. Return plugin spec table
3. Lazy.nvim auto-loads it

Example:
```lua
return {
  "author/plugin-name",
  event = "VeryLazy",
  config = function()
    -- Setup here
  end,
}
```