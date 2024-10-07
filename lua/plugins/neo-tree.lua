-- Neo-tree is a Neovim plugin to browse the file system https://github.com/nvim-neo-tree/neo-tree.nvim


function ToggleNeoTree()
    for _, win in ipairs(vim.api.nvim_list_wins()) do
        local buf = vim.api.nvim_win_get_buf(win)
        local name = vim.api.nvim_buf_get_name(buf)
        if name:match("neo.tree filesystem") ~= nil then
            vim.cmd("Neotree close")
            return
        end
    end
    vim.cmd("Neotree reveal")
end

return {
    'nvim-neo-tree/neo-tree.nvim',
    version = '*',
    dependencies = {
        'nvim-lua/plenary.nvim',
        'nvim-tree/nvim-web-devicons',
        'MunifTanjim/nui.nvim',
    },
    cmd = 'Neotree',
    keys = {
        { '\\', ':lua ToggleNeoTree()<CR>', desc = 'Toggle Neotree', silent = true },
    },
    config = function()
        vim.fn.sign_define("DiagnosticSignError", {text = " ", texthl = "DiagnosticSignError"});
        vim.fn.sign_define("DiagnosticSignWarn", {text = " ", texthl = "DiagnosticSignWarn"});
        vim.fn.sign_define("DiagnosticSignInfo", {text = " ", texthl = "DiagnosticSignInfo"});
        vim.fn.sign_define("DiagnosticSignHint", {text = "", texthl = "DiagnosticSignHint"});

        require("nvim-web-devicons").setup({
            override = {
                txt = {
                    icon = "",
                    name = "txt",
                },
            }
        })

        require('neo-tree').setup({
            close_if_last_window = true, -- Close Neo-tree if it is the last window left in the tab
            popup_border_style = "rounded",
            enable_git_status = true,
            enable_diagnostics = true,
            open_files_do_not_replace_types = { "terminal", "trouble", "qf" }, -- when opening files, do not use windows containing these filetypes or buftypes
            sort_case_insensitive = true, -- used when sorting files and directories in the tree
            default_component_configs = {
            container = {
                enable_character_fade = true
            },
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "",
                default = "*",
                highlight = "NeoTreeFileIcon"
            },
            modified = {
                symbol = "[+]",
                highlight = "NeoTreeModified",
            },
            name = {
                trailing_slash = false,
                use_git_status_colors = true,
                highlight = "NeoTreeFileName",
            },
            git_status = {
                symbols = {
                -- Change type
                added     = "✚", -- or "✚", but this is redundant info if you use git_status_colors on the name
                modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                deleted   = "𝗑",-- this can only be used in the git_status source
                renamed   = "➜",-- this can only be used in the git_status source
                -- Status type
                untracked = "",
                ignored = "",
                unstaged = "",
                staged = "",
                conflict = "",
                }
            },
        },
      });
  end
}
