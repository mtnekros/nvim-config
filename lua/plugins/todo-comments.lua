return {
    "folke/todo-comments.nvim",
    event = "VimEnter",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
        signs = false,
        keywords = {
            ASK = {
                icon = "",
                color = "warning",
                alt = {"QUESTION"},
            },
        },
    },
};

