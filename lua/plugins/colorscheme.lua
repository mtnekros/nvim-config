return { -- You can easily change to a different colorscheme.
	-- Change the name of the colorscheme plugin below, and then
	-- change the command in the config to whatever the name of that colorscheme is.
	--
	-- If you want to see what colorschemes are already installed, you can use `:Telescope colorscheme`.
	"joshdick/onedark.vim",
	priority = 1000, -- Make sure to load this before all the other start plugins.
	init = function()
		-- Load the colorscheme here.
		-- Like many other themes, this one has different styles, and you could load
		-- any other, such as 'tokyonight-storm', 'tokyonight-moon', or 'tokyonight-day'.
		vim.cmd.colorscheme("onedark")
		if vim.fn.empty(vim.env.TMUX) == 1 then
			if vim.fn.has("nvim") == 1 then
				vim.env.NVIM_TUI_ENABLE_TRUE_COLOR = 1
			end
		end
		if (vim.fn.has("termguicolors")) == 1 then
			vim.cmd("set termguicolors")
		end

		-- transparent background
		vim.api.nvim_set_hl(0, "Normal", { bg = "none" }) -- for normal windows
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" }) -- for floating windows
        -- set RenderMarkdown related highlights
        vim.api.nvim_set_hl(0, "RenderMarkdownH2", {fg="#282c34", bg="#e5c07b"})
        vim.api.nvim_set_hl(0, "RenderMarkdownH2Bg", {fg="#282c34", bg="#e5c07b"})
        vim.api.nvim_set_hl(0, "RenderMarkdownBullet", {fg="#e06c75"})
        vim.api.nvim_set_hl(0, "markdownCode", {fg="#e5c07b"})
        vim.api.nvim_set_hl(0, "markdownCodeBlock", {fg="#e5c07b"})
	end,
}
