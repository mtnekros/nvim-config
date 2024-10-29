return {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
        width = "block",
        right_pad = 1,
        heading = {
            left_pad = 1,
            right_pad = 2,
            enabled = true,
            width = "block",
            sign = true,
        },
        code = {
            language_name = true,
            style = "language",
            sign = true,
            highlight = "RenderMarkdownCode",
            highlight_inline = 'RenderMarkdownCodeInline',
            left_pad = 1,
            right_pad = 1,
        },
        checkbox = {
            position = "overlay",
            checked = { icon = ' ' },
            unchecked = { icon = ' ' },
            custom = {
                inprogress = { raw = '[/]', rendered = ' ', highlight = 'Special' },
                important = { raw = '[~]', rendered = '󰓎 ', highlight = 'DiagnosticWarn' },
            }
        },
        bullet = {
            icons = { '', '', '󰺕', '󰓏', '󰻂', '', '󰪥'},
        }
    },
    config = function(_, opts)
        require("render-markdown").setup(opts)

    end
}
