local function clear_luasnip_ns()
    local ns_id = vim.api.nvim_create_namespace("Luasnip") -- this is created by luasnip when using ext opts
    vim.api.nvim_buf_clear_namespace(0, ns_id, 0, -1)
end

return { -- Autocompletion
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		-- Snippet Engine & its associated nvim-cmp source
		{
			"L3MON4D3/LuaSnip",
			build = (function()
				-- Build Step is needed for regex support in snippets.
				-- This step is not supported in many windows environments.
				-- Remove the below condition to re-enable on windows.
				if vim.fn.has("win32") == 1 or vim.fn.executable("make") == 0 then
					return
				end
				return "make install_jsregexp"
			end)(),
			dependencies = {
                -- for vscode style snippets
				{
				  'rafamadriz/friendly-snippets',
				  config = function()
				    require('luasnip.loaders.from_vscode').lazy_load()
				  end,
				},
			},
		},
		"saadparwaiz1/cmp_luasnip",

		-- Adds other completion capabilities.
		--  nvim-cmp does not ship with all sources by default. They are split
		--  into multiple repos for maintenance purposes.
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lsp-signature-help", -- for completion in function arguments
	},
	config = function()
		-- See `:help cmp`
		local cmp = require("cmp")
		local luasnip = require("luasnip")
        local types = require("luasnip.util.types")
		luasnip.config.setup({
            ext_opts = {
                [types.choiceNode] = {
                    active = {
                        virt_text = {{" Current Choice", "Comment"}},
                    },
                },
            }
        })

        -- this is best compromise i could come up with to clear the extmarks
        -- from luasnip (ext_opts: choice node extmarks)
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = vim.api.nvim_create_augroup("LuaSnipAG", {clear = true}),
            callback = clear_luasnip_ns,
        })
        vim.api.nvim_create_user_command("ClearSnipNs", clear_luasnip_ns, {})

        -- setup nvim-cmp mappings & settings
		cmp.setup({
			snippet = {
				expand = function(args)
					luasnip.lsp_expand(args.body)
				end,
			},
			completion = { completeopt = "menu,menuone,noinsert,noselect" },

			mapping = cmp.mapping.preset.insert({
				["<C-n>"] = cmp.mapping.select_next_item(),
				["<C-p>"] = cmp.mapping.select_prev_item(),

				-- Scroll the documentation window [b]ack / [f]orward
				["<C-b>"] = cmp.mapping.scroll_docs(-4),
				["<C-f>"] = cmp.mapping.scroll_docs(4),

				-- Accept ([y]es) the completion.
				--  This will auto-import if your LSP supports it.
				--  This will expand snippets if the LSP sent a snippet.
				["<C-y>"] = cmp.mapping.confirm({ select = true }),

				-- Manually trigger a completion from nvim-cmp.
				--  Generally you don't need this, because nvim-cmp will display
				--  completions whenever it has completion options available.
				["<C-Space>"] = cmp.mapping.complete({}),

                -- move through the snippet customizable <++> arguments
				["<C-l>"] = cmp.mapping(function()
					if luasnip.expand_or_locally_jumpable() then
						luasnip.expand_or_jump()
					end
				end, { "i", "s" }),
				["<C-h>"] = cmp.mapping(function()
					if luasnip.locally_jumpable(-1) then
						luasnip.jump(-1)
					end
				end, { "i", "s" }),
                ["<C-j>"] = cmp.mapping(function()
                    if luasnip.choice_active() then
                        luasnip.change_choice(1)
                    else
                        print("No active choice")
                    end
                end, {"i", "s"}),
                ["<C-k>"] = cmp.mapping(function()
                    if luasnip.choice_active() then
                        luasnip.change_choice(-1)
                    else
                        print("No active choice")
                    end
                end, {"i", "s"}),
                }),
			sources = {
				{
					name = "lazydev",
					-- set group index to 0 to skip loading LuaLS completions as lazydev recommends it
					group_index = 0,
				},
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
                { name = "nvim_lsp_signature_help" },
                { name = "vim-dadbod-completion" }, -- for sql completion
			},
		})

        -- add custom snippets
        for _, ft_path in ipairs(vim.api.nvim_get_runtime_file("lua/custom/snippets/*.lua", true)) do
            loadfile(ft_path)()
        end
	end,
}
