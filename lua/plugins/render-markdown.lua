return {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
        width = "block",
        right_pad = 1,
        heading = {
            left_pad = 1,
            right_pad = 1,
            enabled = true,
            width = "block",
            sign = true,
            border = true,
            border_virtual = true,
        },
        code = {
            language_name = false,
            style = "block",
            sign = true,
            highlight = "RenderMarkdownCode",
            left_pad = 1,
            right_pad = 1,
        },
        checkbox = {
            position = "overlay",
            custom = {
                inprogress = { raw = '[/]', rendered = '󰲽 ', highlight = 'FloatTitle' },
                important = { raw = '[~]', rendered = '󰓎 ', highlight = 'DiagnosticWarn' },
            }
        }
    },
    config = function(_, opts)
        require("render-markdown").setup(opts)
        vim.api.nvim_create_user_command("ToggleMarkdown", function()
            local m = require("render-markdown")
            if require("render-markdown.state").enabled then
                m.enable()
            else
                m.disable()
            end
        end, { bang = true })
        vim.api.nvim_set_hl( 0, "RenderMarkdownH2", {fg="#282c34", bg="#e5c07b"})
        vim.api.nvim_set_hl( 0, "RenderMarkdownH2Bg", {fg="#282c34", bg="#e5c07b"})
    end
}
