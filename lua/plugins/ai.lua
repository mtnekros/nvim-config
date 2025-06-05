
return { -- Autoformat
    "github/copilot.vim",
    config = function()
        vim.keymap.set('i', '<C-Y>', 'copilot#Accept("\\<CR>")', {
            expr = true,
            replace_keycodes = false
        })
        vim.g.copilot_no_tab_map = true
        vim.api.nvim_create_autocmd("BufEnter", {
            pattern = "*",
            callback = function()
                vim.cmd("Copilot disable")
            end,
        })
        vim.cmd("Copilot disable")
    end,
}

