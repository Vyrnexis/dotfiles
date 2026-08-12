-- ==============================================================================
-- 🩺 DIAGNOSTICS & ERRORS
-- ==============================================================================

-- Map <leader>d to gather all LSP diagnostics (errors/warnings) in the current project
-- and display them neatly in a quickfix window at the bottom of the screen.
vim.keymap.set("n", "<leader>d", function()
	vim.diagnostic.setqflist()
	vim.cmd("copen")
end, { silent = true, desc = "Open diagnostics quickfix list" })
