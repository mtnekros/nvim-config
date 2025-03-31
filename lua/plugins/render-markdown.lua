return {
    "MeanderingProgrammer/render-markdown.nvim",
    opts = {
        width = "block",
        right_pad = 1,
        heading = {
            left_pad = 1,
            right_pad = 2,
            position = "inline",
            enabled = true,
            width = "block",
            sign = true,
            icons = { '󰫎 ', '󰫎 ', '󰫎 ', '󰫎 ', '󰫎 ', '󰫎 ' },
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
            checked = { icon = '󰸞 ', highlight = 'Special' },
            unchecked = { icon = ' ', highlight = 'Special' },
            custom = {
                inprogress = { raw = '[/]', rendered = ' ', highlight = 'DiagnosticWarn' },
                postponed = { raw = '[>]', rendered = '󰜴 ', highlight = 'DiagnosticWarn' },

            }
        },
        bullet = {
            icons = { '  ', '󰺕  ', '󰄰  ', '󰻂  ', '󰪥  ', '  '},
        }
    },
    config = function(_, opts)
        require("render-markdown").setup(opts)

    end
}
