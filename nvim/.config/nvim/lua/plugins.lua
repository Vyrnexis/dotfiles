-- ==============================================================================
-- NATIVE PACKAGE MANAGEMENT
-- ==============================================================================

-- Add plugins natively using Neovim 0.12's vim.pack.add
vim.pack.add({ "https://github.com/nvim-treesitter/nvim-treesitter" })
vim.pack.add({ "https://github.com/brenoprata10/nvim-highlight-colors" })

-- ==============================================================================
-- TREESITTER SETUP
-- ==============================================================================

-- Configure Treesitter parsers to automatically install and run
vim.treesitter.start = (function(orig)
	return function(bufnr)
		-- Ensure parsers are installed for these languages
		require("nvim-treesitter").install({
			"c",
			"lua",
			"vim",
			"vimdoc",
			"query",
			"python",
			"go",
			"nim",
			"pascal",
			"markdown",
			"markdown_inline",
		})
		-- Start Treesitter syntax highlighting
		return orig(bufnr)
	end
end)(vim.treesitter.start)

-- Actually trigger the syntax highlighting engine on all filetypes
vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		pcall(vim.treesitter.start)
	end,
})
-- ==============================================================================
-- COLOR HIGHLIGHTER SETUP
-- ==============================================================================

-- Automatically render virtual color boxes next to hex/rgb codes
vim.schedule(function()
	local ok, highlighter = pcall(require, "nvim-highlight-colors")
	if ok then
		highlighter.setup({
			render = "virtual",          -- place a virtual box next to the code
			virtual_symbol = "■",        -- the shape of the icon
			enable_named_colors = true,  -- enable things like 'red', 'blue'
			enable_tailwind = false,     -- we don't need tailwind overhead
		})
	end
end)
