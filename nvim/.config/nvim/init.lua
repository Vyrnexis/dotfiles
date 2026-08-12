-- ==============================================================================
-- 🚀 NEOVIM 0.12+ MINIMALIST CONFIGURATION ENTRY POINT
-- ==============================================================================
-- This is the main entry point for Neovim. It simply sets the leader key
-- and then loads all the modular configuration files from the `lua/` directory.

-- Set the leader key to Space (must happen before anything else is loaded)
vim.g.mapleader = " "

-- Load core settings
require("options")
require("keymaps")
require("colorscheme")

-- Load built-in Neovim tools & overrides
require("netrw")
require("statusline")
require("search")
require("autocommands")
require("diagnostics")

-- Load LSP, formatting, and syntax handling
require("plugins")
require("lsp")
require("formatting")
