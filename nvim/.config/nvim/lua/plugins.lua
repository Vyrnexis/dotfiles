-- ==============================================================================
-- 🧩 NATIVE PACKAGE MANAGEMENT (TREESITTER)
-- ==============================================================================

-- Add nvim-treesitter to the runtimepath natively using Neovim 0.12's vim.pack.add
vim.pack.add({ "nvim-treesitter/nvim-treesitter" })

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
