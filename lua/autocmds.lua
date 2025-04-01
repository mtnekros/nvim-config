vim.api.nvim_create_autocmd("TextYankPost", {
	desc = "Highlight when yanking (copying) text",
	group = vim.api.nvim_create_augroup("kickstart-highlight-yank", { clear = true }),
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("FileType", {
    desc = "Set commentstring in sql files",
    pattern = "sql",
    group = vim.api.nvim_create_augroup("sql-comment-string", {clear = true}),
    callback = function()
        vim.bo.commentstring = "-- %s"
    end,
})


vim.api.nvim_create_autocmd("FileType", {
    desc = "Ignore linting errors in a python file",
    pattern = "python",
    group = vim.api.nvim_create_augroup("ignore-python-errors", {clear = true}),
    callback = function()
        vim.keymap.set("n", "<leader>ie", function()
            vim.cmd("call append(0, '# type: ignore')")
            vim.cmd("call append(0, '# ruff: noqa')")
        end, {noremap =true})
    end,
})
