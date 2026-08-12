-- ==============================================================================
-- ⌨️ GENERAL KEYMAPS
-- ==============================================================================

-- Write and quit shortcuts
vim.keymap.set("n", "<leader>w", ":w<cr>", { silent = true, desc = "Save file" })
vim.keymap.set("n", "<leader>q", ":q<cr>", { silent = true, desc = "Quit Neovim" })

-- Redo (Undo is naturally bound to 'u', we bind 'U' for Redo instead of Ctrl+r)
vim.keymap.set("n", "U", "<c-r>", { silent = true, desc = "Redo" })

-- Window navigation (swap between split buffers quickly using Ctrl + hjkl)
vim.keymap.set("n", "<C-h>", ":wincmd h<CR>", { silent = true, desc = "Move to left split" })
vim.keymap.set("n", "<C-j>", ":wincmd j<CR>", { silent = true, desc = "Move to below split" })
vim.keymap.set("n", "<C-k>", ":wincmd k<CR>", { silent = true, desc = "Move to above split" })
vim.keymap.set("n", "<C-l>", ":wincmd l<CR>", { silent = true, desc = "Move to right split" })
