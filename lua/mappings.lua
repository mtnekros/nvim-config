-- MAPPINGS
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostic [Q]uickfix list" })

vim.keymap.set({ "n", "v", "i" }, "<A-h>", "<C-w><C-h>", { desc = "Move focus to the left window" })
vim.keymap.set({ "n", "v", "i" }, "<A-l>", "<C-w><C-l>", { desc = "Move focus to the right window" })
vim.keymap.set({ "n", "v", "i" }, "<A-j>", "<C-w><C-j>", { desc = "Move focus to the lower window" })
vim.keymap.set({ "n", "v", "i" }, "<A-k>", "<C-w><C-k>", { desc = "Move focus to the upper window" })

vim.cmd([[
    inoremap <A-h> <C-\><C-n><C-w>h
    inoremap <A-j> <C-\><C-n><C-w>j
    inoremap <A-k> <C-\><C-n><C-w>k
    inoremap <A-l> <C-\><C-n><C-w>l
    " terminal mode
    tnoremap <A-h> <C-\><C-n><C-w>h
    tnoremap <A-j> <C-\><C-n><C-w>j
    tnoremap <A-k> <C-\><C-n><C-w>k
    tnoremap <A-l> <C-\><C-n><C-w>l
]])

-- resizing windows
vim.keymap.set("n", "<A-Left>", "<CMD> vertical resize -2<CR>")
vim.keymap.set("n", "<A-Right>", "<CMD> vertical resize +2<CR>")
vim.keymap.set("n", "<A-Up>", "<CMD> resize +2<CR>")
vim.keymap.set("n", "<A-Down>", "<CMD> resize +2<CR>")

-- Mapping for quickfixlist
vim.keymap.set("n", "<C-j>", "<cmd>cnext<cr>", { silent = true })
vim.keymap.set("n", "<C-k>", "<cmd>cprev<cr>", { silent = true })

-- mapping for opening frequently used files
vim.keymap.set("n", "<leader>v", "<cmd>source $MYVIMRC<cr>")
vim.keymap.set("n", "<leader>V", "<cmd>edit ~/AppData/Local/nvim/init.lua<cr>")
vim.keymap.set("n", "<leader>w", "<cmd>edit ~\\OneDrive\\ -\\ Verisk\\ Analytics\\Desktop\\Notes\\Work\\tasks.md<cr>")

-- mapping for my projects
vim.keymap.set("n", "<leader>fs", "<cmd>set filetype=sql<cr>")
vim.keymap.set("n", "<leader>df", "<cmd>filetype detect<cr>")

