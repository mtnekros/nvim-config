vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

vim.g.python3_host_prog = "C:\\Users\\mtnek\\AppData\\Local\\Programs\\Python\\Python312\\python.exe"

-- My personal settings
vim.opt.number = true -- Make line numbers default
vim.opt.relativenumber = true
vim.opt.mouse = "a" -- Enable mouse mode, can be useful for resizing splits for example!
vim.opt.wildmenu = true
vim.opt.path:append("**")
vim.opt.wildignore = vim.opt.wildignore + { "**/node_modules/**", "**/venv/**", "**/*.pyc", "**/*.py~" }
vim.opt.wildmenu = true
vim.opt.showmode = true -- hide mode sinces powerline plugin already shows it
vim.opt.guicursor = "i:block" -- make cursor fat in insert mode like in vim
vim.opt.incsearch = true
vim.opt.swapfile = false
vim.opt.hlsearch = false
vim.opt.undofile = true
vim.opt.undodir = vim.fn.stdpath("data") .. "\\undo"
vim.opt.exrc = true
vim.opt.cursorline = true -- highlight cursorline
vim.opt.colorcolumn = "80" -- highlight column after textwidth 80
vim.cmd.hi("ColorColumn ctermbg=Gray guibg=#3a3a3a") -- highlight column color to grey
vim.opt.wrap = false
vim.cmd("set shiftround") -- " round indent to multiple of 'shiftwidth'"
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.smartindent = true
vim.opt.autoindent = true
vim.opt.expandtab = true
vim.schedule(function()
	vim.opt.clipboard = "unnamedplus"
end)
vim.opt.breakindent = true -- Enable break indent
-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.signcolumn = "yes" -- Keep signcolumn on by default
vim.opt.updatetime = 250 -- Decrease update time
-- Decrease mapped sequence wait time
-- Displays which-key popup sooner
vim.opt.timeoutlen = 300
vim.opt.splitright = true -- Configure how new splits should be opened
-- Sets how neovim will display certain whitespace characters in the editor.
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "", nbsp = "␣", eol = "󰌑" }

vim.opt.inccommand = "split" -- Preview substitutions live, as you type!
vim.opt.scrolloff = 2 -- Minimal number of screen lines to keep above and below the cursor.
-- don't fold by defaul
vim.opt.foldenable = false
vim.opt.foldmethod = "manual"

