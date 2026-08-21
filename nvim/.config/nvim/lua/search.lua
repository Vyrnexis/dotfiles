-- ==============================================================================
-- RIPGREP BACKED NATIVE SEARCH
-- ==============================================================================

-- Directories and files to always ignore when fuzzy finding
local ignore_patterns = {
	"node_modules",
	"%.git",
	"%.cache",
	"dist",
	"build",
	"%.tmp",
	"%.log",
}

-- NATIVE FUZZY FINDER (:find / <leader>f)
-- Overrides the built-in `:find` command to rapidly search for files using `rg` instead of the slow default globs.
function _G.native_find(text, _)
	local obj = vim.system({ "rg", "--files", "--hidden", "-g", "!.git" }, { text = true }):wait()
	local files = {}
	
	if obj.code == 0 and obj.stdout and obj.stdout ~= "" then
		files = vim.split(obj.stdout, "\n", { trimempty = true })
	else
		files = vim.fn.glob("**/*", true, true)
	end

	local result = {}
	for _, f in ipairs(files) do
		if vim.fn.isdirectory(f) == 0 then
			local skip = false
			for _, pat in ipairs(ignore_patterns) do
				if f:match(pat) then
					skip = true
					break
				end
			end
			if not skip then
				result[#result + 1] = f
			end
		end
	end
	return vim.fn.matchfuzzy(result, text)
end

vim.opt.findfunc = "v:lua.native_find"
vim.keymap.set("n", "<leader>f", ":find ", { silent = false, desc = "Fuzzy find files" })

-- GLOBAL GREP (<leader>g)
-- Configures the `:grep` command to use ripgrep under the hood, and provides a prompt mapping.
vim.opt.grepprg = "rg --vimgrep --smart-case --hidden"
vim.opt.grepformat = "%f:%l:%c:%m"

vim.keymap.set("n", "<leader>g", function()
	vim.ui.input({ prompt = "Grep: " }, function(pattern)
		if pattern and pattern ~= "" then
			vim.cmd("silent grep! " .. vim.fn.shellescape(pattern))
			vim.cmd("copen")
		end
	end)
end, { silent = true, desc = "Grep text across project" })
