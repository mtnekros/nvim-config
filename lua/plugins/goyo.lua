return {
	"junegunn/goyo.vim",
	config = function()
		vim.g.goyo_width = 100
        vim.g.goyo_height = '100%'
        local default_wrap = vim.opt.wrap
        local default_list = vim.opt.list
        local defaul_laststatus = vim.opt.laststatus
        vim.api.nvim_create_autocmd("User", {
            group=vim.api.nvim_create_augroup("goyo-enter", {clear=true}),
            pattern="GoyoEnter",
            callback=function()
                default_wrap = vim.opt.wrap
                default_list = vim.opt.list
                defaul_laststatus = vim.opt.laststatus
                vim.opt.wrap = true
                vim.opt.list = false
                vim.opt.laststatus = 0
            end
        })
        vim.api.nvim_create_autocmd("User", {
            group=vim.api.nvim_create_augroup("goyo-leave", {clear=true}),
            pattern="GoyoLeave",
            callback=function()
                vim.opt.wrap = default_wrap
                vim.opt.list = default_list
                vim.opt.laststatus = defaul_laststatus
            end
        })
	end,
}
