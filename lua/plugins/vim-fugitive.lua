return {
	"tpope/vim-fugitive",
    lazy = false,
	keys = {
		{ "<leader>gs", ":Git<CR>", desc = "[G]it [S]tatus" },
		{ "<leader>gj", ":diffget //3<CR> ", desc = "[G]it [R]ight" },
		{ "<leader>gf", ":diffget //2<CR> ", desc = "[G]it [L]eft" },
	},
}
