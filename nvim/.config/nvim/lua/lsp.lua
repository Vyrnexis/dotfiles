-- ==============================================================================
-- 🧠 LANGUAGE SERVER PROTOCOL (LSP)
-- ==============================================================================

-- Enable Language Servers natively using Neovim 0.11/0.12 APIs
vim.lsp.enable({ "lua_ls", "pyright", "gopls", "nimls", "pasls" })

-- Enable virtual text (inline error messages next to the code)
vim.diagnostic.config({ virtual_text = true })

-- Automatically attach native autocomplete when an LSP server connects
vim.api.nvim_create_autocmd("LspAttach", {
	callback = function(ev)
		local client = vim.lsp.get_client_by_id(ev.data.client_id)
		if client ~= nil and client:supports_method("textDocument/completion") then
			vim.lsp.completion.enable(true, client.id, ev.buf, { autotrigger = true })
		end
	end,
})

-- Prevent autocomplete popup from automatically selecting the first item
vim.cmd("set completeopt+=noselect")
