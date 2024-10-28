-- lazy setup
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		error("Error cloning lazy.nvim:\n" .. out)
	end
end ---@diagnostic disable-next-line: undefined-field
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
	-- "tpope/vim-sleuth", -- Detect tabstop and shiftwidth automatically
    require("plugins.render-markdown"),
	require("plugins.which-key"),
	require("plugins.telescope"),
	-- LSP Plugins
	require("plugins.lazy-dev"),
	{ "Bilal2453/luvit-meta", lazy = true },
	require("plugins.lsp"),
	require("plugins.nvim-cmp"),
	require("plugins.conform"),
	require("plugins.todo-comments"),
	require("plugins.mini"),
	require("plugins.treesitter"),
    require("plugins.goyo"),
	-- require 'kickstart.plugins.debug',
	-- require 'kickstart.plugins.indent_line',
	-- require 'kickstart.plugins.lint',
	-- require 'kickstart.plugins.autopairs',
	require("plugins.neo-tree"),
	require("plugins.gitsigns"), -- adds gitsigns recommend keymaps
	require("plugins.vim-fugitive"),
	require("plugins.vim-surround"),
	require("plugins.onedark"),
}, {
	ui = {
		icons = vim.g.have_nerd_font and {} or {
			cmd = "⌘",
			config = "🛠",
			event = "📅",
			ft = "📂",
			init = "⚙",
			keys = "🗝",
			plugin = "🔌",
			runtime = "💻",
			require = "🌙",
			source = "📄",
			start = "🚀",
			task = "📌",
			lazy = "💤 ",
		},
	},
})

