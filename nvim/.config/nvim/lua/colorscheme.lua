-- ==============================================================================
-- 🎨 COLORSCHEME
-- ==============================================================================

-- Set the global colorscheme
vim.cmd.colorscheme("catppuccin")

-- Force the background of the normal text area to be transparent
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
