return {
	"junegunn/goyo.vim",
	config = function()
		vim.g.goyo_width = 85
        vim.g.goyo_height = '100%'
        local default_opts = {}
        local mappings = {
            { mode = "n", keys = "j", action = "gj", opts = {noremap = true}},
            { mode = "n", keys = "k", action = "gk", opts = {noremap = true}},
            { mode = "n", keys = "0", action = "g0", opts = {noremap = true}},
            { mode = "n", keys = "I", action = "gI", opts = {noremap = true}},
            { mode = "n", keys = "$", action = "g$", opts = {noremap = true}},
        }
        local default_hl_normal = vim.api.nvim_get_hl(0, {name = "Normal"})
        local default_hl_normal_float = vim.api.nvim_get_hl(0, {name = "NormalFloat"})

        vim.api.nvim_create_autocmd("User", {
            group=vim.api.nvim_create_augroup("goyo-enter", {clear=true}),
            pattern="GoyoEnter",
            callback=function()
                -- save default options
                default_opts = {
                    wrap = vim.opt.wrap,
                    list = vim.opt.list,
                    cursorline = vim.opt.cursorline,
                }
                default_hl_normal = vim.api.nvim_get_hl(0, {name = "Normal"})
                default_hl_normal_float = vim.api.nvim_get_hl(0, {name = "NormalFloat"})
                -- set goyo options
                vim.opt.wrap = true
                vim.opt.list = false
                vim.opt.cursorline = false
                -- highlights
                vim.api.nvim_set_hl(0, "Normal", {bg = "black"})
                vim.api.nvim_set_hl(0, "NormalFloat", {bg = "black"})
                -- keymaps
                for _, map in pairs(mappings) do
                    vim.keymap.set(map.mode, map.keys, map.action, map.opts)
                end
            end
        })

        vim.api.nvim_create_autocmd("User", {
            group=vim.api.nvim_create_augroup("goyo-leave", {clear=true}),
            pattern="GoyoLeave",
            callback=function()
                vim.api.nvim_set_hl(0, "Normal", vim.tbl_extend("force", {}, default_hl_normal))
                vim.api.nvim_set_hl(0, "NormalFloat", vim.tbl_extend("force", {}, default_hl_normal_float))
                for name,value in pairs(default_opts) do
                    vim.opt[name] = value
                end
                for _, map in pairs(mappings) do
                    vim.keymap.del(map.mode, map.keys)
                end
            end
        })
	end,
}

