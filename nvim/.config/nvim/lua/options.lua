-- ==============================================================================
-- ⚙️ CORE OPTIONS
-- ==============================================================================

vim.o.number = true           -- Show absolute line numbers
vim.o.relativenumber = true   -- Show relative line numbers for easy jumping
vim.o.tabstop = 2             -- Number of spaces that a <Tab> counts for
vim.o.softtabstop = 2         -- Number of spaces that a <Tab> counts for while editing
vim.o.signcolumn = "yes"      -- Always show the signcolumn to prevent text shifting
vim.o.undofile = true         -- Enable persistent undo (saves undo history across sessions)
vim.o.autoread = true         -- Automatically re-read files if modified outside Neovim
vim.o.laststatus = 3          -- Global statusline (only one statusline at the bottom)
vim.o.cmdheight = 0           -- Hide the command line when not actively typing a command
