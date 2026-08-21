-- ==============================================================================
-- AUTO-FORMATTING ON SAVE
-- ==============================================================================
local M = {}

-- User-configurable mapping: filetype -> function returning the CLI command array
-- This uses the safe and fast `vim.system()` API instead of spinning up an OS shell.
M.formatters = {
	lua = function(_) return { "stylua", "-" } end,
	python = function(_) return { "black", "-q", "-" } end,
	json = function(_) return { "jq", "." } end,
	toml = function(_) return { "taplo", "format", "-" } end,
	-- Markdown uses prettier, which requires the actual filename to know how to parse it
	markdown = function(bufname) return { "prettier", "--stdin-filepath", bufname } end,
}

-- Trigger formatting right before saving any buffer (`BufWritePre`)
vim.api.nvim_create_autocmd("BufWritePre", {
	callback = function(args)
		local bufnr = args.buf
		local ft = vim.bo[bufnr].filetype
		local cmd_generator = M.formatters[ft]

		if cmd_generator then
			-- 1. Get the current buffer contents
			local bufname = vim.api.nvim_buf_get_name(bufnr)
			local cmd_args = cmd_generator(bufname)
			local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
			local input = table.concat(lines, "\n")

			-- 2. Execute the formatter silently in the background
			local obj = vim.system(cmd_args, { stdin = input, text = true }):wait()

			-- 3. If formatting succeeded, replace the buffer contents
			if obj.code == 0 and obj.stdout then
				local formatted = vim.split(obj.stdout, "\n", { plain = true })
				-- Remove the trailing empty line that shell commands often append
				if formatted[#formatted] == "" then
					table.remove(formatted)
				end
				vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, formatted)
			end
		else
			-- No CLI formatter defined: fallback to LSP formatting (if the language server supports it)
			for _, cl in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
				if cl:supports_method("textDocument/formatting") then
					vim.lsp.buf.format({ bufnr = bufnr, async = false })
					break
				end
			end
		end
	end,
})

return M
