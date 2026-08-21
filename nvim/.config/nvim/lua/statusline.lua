-- ==============================================================================
-- ASYNCHRONOUS GIT STATUSLINE
-- ==============================================================================
-- This statusline avoids blocking the UI by querying Git branch/root information
-- asynchronously in the background every time a buffer is entered.

-- Pull colors from the global colorscheme to make the statusline look native
local pms = vim.api.nvim_get_hl(0, { name = "PmenuSel", link = false })
local dir = vim.api.nvim_get_hl(0, { name = "Directory", link = false })
local vis = vim.api.nvim_get_hl(0, { name = "Visual", link = false })
vim.api.nvim_set_hl(0, "StlMode", { fg = pms.fg, bg = vis.bg })
vim.api.nvim_set_hl(0, "StlGit", { fg = dir.fg, bg = pms.bg })

-- Map internal Neovim modes to human-readable strings
local modes = {
	n = "NORMAL",
	i = "INSERT",
	v = "VISUAL",
	V = "V-LINE",
	["\22"] = "V-BLOCK",
	c = "COMMAND",
	t = "TERMINAL",
	R = "REPLACE",
	s = "SELECT",
	S = "S-LINE",
	["\19"] = "S-BLOCK",
}

-- The function that paints the statusline on every keystroke/redraw
function _G._statusline()
	local mode = modes[vim.fn.mode()] or vim.fn.mode():upper()
	local branch = vim.b.git_branch and "%#StlGit# " .. vim.b.git_branch .. " %*" or ""
	local path = vim.b.rel_path or "%f"

	local diag = ""
	local counts = vim.diagnostic.count(0) or {}
	local labels = { " ", " ", " ", " " }
	local hls = { "DiagnosticError", "DiagnosticWarn", "DiagnosticInfo", "DiagnosticHint" }
	
	-- Build the diagnostics string (only showing active errors/warnings)
	for i = 1, 4 do
		if counts[i] and counts[i] > 0 then
			diag = diag .. "%#" .. hls[i] .. "#" .. labels[i] .. counts[i] .. "%* "
		end
	end

	-- Stitch the left side (Mode, Branch, Path) and right side (Diagnostics, Filetype, Line:Col) together
	return "%#StlMode# " .. mode .. " %*" .. branch .. " " .. path .. "%=" .. diag .. vim.bo.filetype .. " %l:%c"
end

-- Asynchronously fetch Git branch and repo root when entering a buffer
vim.api.nvim_create_autocmd("BufEnter", {
	callback = function(args)
		local bufnr = args.buf
		local bufname = vim.api.nvim_buf_get_name(bufnr)
		local lookup_dir = bufname ~= "" and vim.fn.fnamemodify(bufname, ":h") or vim.fn.getcwd()
		-- Set defaults immediately so statusline doesn't flicker empty
		vim.b[bufnr].rel_path = vim.fn.expand("%:p:~")
		vim.b[bufnr].git_branch = nil

		-- Run `git rev-parse` asynchronously
		vim.system({ "git", "-C", lookup_dir, "rev-parse", "--show-toplevel" }, { text = true }, function(out_root)
			if out_root.code == 0 and out_root.stdout then
				local root = out_root.stdout:gsub("%s+$", "")
				if root ~= "" then
					vim.schedule(function()
						if vim.api.nvim_buf_is_valid(bufnr) then
							-- Trim the absolute path to make it relative to the git root
							local current_name = vim.api.nvim_buf_get_name(bufnr)
							if current_name:sub(1, #root + 1) == root .. "/" then
								vim.b[bufnr].rel_path = current_name:sub(#root + 2)
							end
						end
					end)

					-- Run `git branch` asynchronously
					vim.system({ "git", "-C", root, "branch", "--show-current" }, { text = true }, function(out_branch)
						if out_branch.code == 0 and out_branch.stdout then
							local branch = out_branch.stdout:gsub("%s+$", "")
							vim.schedule(function()
								if vim.api.nvim_buf_is_valid(bufnr) then
									vim.b[bufnr].git_branch = branch
									vim.cmd("redrawstatus")
								end
							end)
						end
					end)
				end
			end
		end)
	end,
})

-- Force a redraw when diagnostics change (e.g. you fixed an error)
vim.api.nvim_create_autocmd("DiagnosticChanged", {
	callback = function()
		vim.cmd("redrawstatus!")
	end,
})

vim.o.statusline = "%!v:lua._statusline()"
