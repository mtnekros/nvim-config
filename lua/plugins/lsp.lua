return {
    -- Main LSP Configuration
    "neovim/nvim-lspconfig",
    dependencies = {
        -- Automatically install LSPs and related tools to stdpath for Neovim
        { "williamboman/mason.nvim", config = true }, -- NOTE: Must be loaded before dependants
        "williamboman/mason-lspconfig.nvim",
        "WhoIsSethDaniel/mason-tool-installer.nvim",
        { "j-hui/fidget.nvim", opts = {} },
        -- Allows extra capabilities provided by nvim-cmp
        "hrsh7th/cmp-nvim-lsp",
        {
            "nvimdev/lspsaga.nvim",
            dependencies = {
                "nvim-treesitter/nvim-treesitter", -- optional
                "nvim-tree/nvim-web-devicons", -- optional
            },
        }, -- LSP Saga for better LSP UI and breadcrumb
    },
    config = function()
        -- setup lsp saga before autocommand
        require("lspsaga").setup({
            lightbulb = { enable = false },
            symbol_in_winbar = {
                enable = true,
                separator = " > ",
                hide_keyword = false,
                show_file = true,
                folder_level = 1,
                color_mode = true,
            },
        })

        vim.api.nvim_create_autocmd("LspAttach", {
            group = vim.api.nvim_create_augroup("kickstart-lsp-attach", { clear = true }),
            callback = function(event)
                -- NOTE: Remember that Lua is a real programming language, and as such it is possible
                -- to define small helper and utility functions so you don't have to repeat yourself.
                --
                -- In this case, we create a function that lets us more easily define mappings specific
                -- for LSP related items. It sets the mode, buffer and description for us each time.
                local map = function(keys, func, desc, mode)
                    mode = mode or "n"
                    vim.keymap.set(mode, keys, func, { buffer = event.buf, desc = "LSP: " .. desc })
                end

                -- Find references for the word under your cursor.
                map("gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
                map("gI", require("telescope.builtin").lsp_implementations, "[G]oto [I]mplementation")
                -- Fuzzy find all the symbols in your current document.
                --  Symbols are things like variables, functions, types, etc.
                map("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
                -- Fuzzy find all the symbols in your current workspace.
                --  Similar to document symbols, except searches over your entire project.
                map("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")
                map("<leader>ld", require("telescope.builtin").diagnostics, "[L]ist [D]iagnostics")

                -- handled in lspsaga
                -- map("gd", require("telescope.builtin").lsp_definitions, "[G]oto [D]efinition")
                map("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction", { "n", "x" , "v"})
                -- map("<F2>", vim.lsp.buf.rename, "Rename")

                -- WARN: This is not Goto Definition, this is Goto Declaration.
                --  For example, in C this would take you to the header.
                map("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")

                -- setup the lspsaga and enable breadcrumb on load
                -- mapping for lsp saga with awesome UIs
                map("gd", "<cmd>Lspsaga goto_definition<cr>", "[G]oto [D]efinition")
                map("<leader>D", "<cmd>Lspsaga goto_type_definition<cr>", "Type [D]efinition")
                map("[d", "<cmd>Lspsaga diagnostic_jump_prev<cr>", "Diagnostic Jump Prev")
                map("]d", "<cmd>Lspsaga diagnostic_jump_next<cr>", "Diagnostic Jump Next")
                map("<F2>", "<cmd>Lspsaga rename<cr>", "Rename")
                map("K", "<cmd>Lspsaga hover_doc<cr>", "Hover Documentation")
                map("<leader>gr", "<cmd>Lspsaga finder<cr>", "Find References")
                -- The following two autocommands are used to highlight references of the
                -- word under your cursor when your cursor rests there for a little while.
                --    See `:help CursorHold` for information about when this is executed
                --
                -- When you move your cursor, the highlights will be cleared (the second autocommand).
                local client = vim.lsp.get_client_by_id(event.data.client_id)
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_documentHighlight) then
                    local highlight_augroup = vim.api.nvim_create_augroup("kickstart-lsp-highlight", { clear = false })
                    vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.document_highlight,
                    })

                    vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
                        buffer = event.buf,
                        group = highlight_augroup,
                        callback = vim.lsp.buf.clear_references,
                    })

                    vim.api.nvim_create_autocmd("LspDetach", {
                        group = vim.api.nvim_create_augroup("kickstart-lsp-detach", { clear = true }),
                        callback = function(event2)
                            vim.lsp.buf.clear_references()
                            vim.api.nvim_clear_autocmds({ group = "kickstart-lsp-highlight", buffer = event2.buf })
                        end,
                    })
                end

                -- The following code creates a keymap to toggle inlay hints in your
                -- code, if the language server you are using supports them
                --
                -- This may be unwanted, since they displace some of your code
                if client and client.supports_method(vim.lsp.protocol.Methods.textDocument_inlayHint) then
                    map("<leader>th", function()
                        vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled({ bufnr = event.buf }))
                    end, "[T]oggle Inlay [H]ints")
                end
            end,
        })

        -- LSP servers and clients are able to communicate to each other what features they support.
        --  By default, Neovim doesn't support everything that is in the LSP specification.
        --  When you add nvim-cmp, luasnip, etc. Neovim now has *more* capabilities.
        --  So, we create new capabilities with nvim cmp, and then broadcast that to the servers.
        local capabilities = vim.lsp.protocol.make_client_capabilities()
        capabilities = vim.tbl_deep_extend("force", capabilities, require("cmp_nvim_lsp").default_capabilities())

        -- Enable the following language servers
        --  Feel free to add/remove any LSPs that you want here. They will automatically be installed.
        --
        --  Add any additional override configuration in the following tables. Available keys are:
        --  - cmd (table): Override the default command used to start the server
        --  - filetypes (table): Override the default list of associated filetypes for the server
        --  - capabilities (table): Override fields in capabilities. Can be used to disable certain LSP features.
        --  - settings (table): Override the default settings passed when initializing the server.
        --        For example, to see the options for `lua_ls`, you could go to: https://luals.github.io/wiki/settings/
        local servers = {
            -- clangd = {},
            -- gopls = {},
            ruff = {
                init_options = {
                    cmd = {"ruff", "server", "--preview"},
                    filetypes = {"python"},
                    settings = {
                        -- ["ruff.configuration"] = "~/.pyproject.toml",
                        lineLength = 120,
                        fixAll = true,
                        lint = {
                            select = {"ANN","B","D","E","F","I","S","SIM","TCH","UP","W","YTT"},
                            ignore = {"ANN101"}, -- disable missing-type-self ANN101
                        },
                        format = {
                            preview = true,
                        },
                        settings = {
                            codeAction = {
                                -- disableRuleComment = {
                                --     enable = { true },
                                -- },
                            },
                        },
                    },
                },
            },
            pyright = {
                settings = {
                    pyright = {
                        -- Using Ruff's import organizer
                        disableOrganizeImports = true,
                    },
                    python = {
                        analysis = {
                            -- typeCheckingMode = "strict",
                        }
                    },
                },
            },
            ts_ls = {},
            lua_ls = {
                -- cmd = {...},
                -- filetypes = { ...},
                -- capabilities = {},
                settings = {
                    Lua = {
                        completion = {
                            callSnippet = "Replace",
                        },
                        -- You can toggle below to ignore Lua_LS's noisy `missing-fields` warnings
                        -- diagnostics = { disable = { 'missing-fields' } },
                    },
                },
            },
        }

        -- Ensure the servers and tools above are installed
        --  To check the current status of installed tools and/or manually install
        --  other tools, you can run
        --    :Mason
        --
        --  You can press `g?` for help in this menu.
        require("mason").setup()

        -- You can add other tools here that you want Mason to install
        -- for you, so that they are available from within Neovim.
        local ensure_installed = vim.tbl_keys(servers or {})
        vim.list_extend(ensure_installed, {
            "stylua", -- Used to format Lua code
        })
        require("mason-tool-installer").setup({ ensure_installed = ensure_installed })

        require("mason-lspconfig").setup({
            ensure_installed={},
            automatic_installation=true,
            handlers = {
                function(server_name)
                    local server = servers[server_name] or {}
                    -- This handles overriding only values explicitly passed
                    -- by the server configuration above. Useful when disabling
                    -- certain features of an LSP (for example, turning off formatting for ts_ls)
                    local on_attach = function(client, bufnr)
                        if client.name == 'ruff' then
                            client.server_capabilities.hoverProvider = false
                        elseif client.name == "pyright" then
                            client.server_capabilities.code_action = false
                            client.server_capabilities.document_formatting = false
                        end
                    end
                    server.capabilities = vim.tbl_deep_extend("force", {}, capabilities, server.capabilities or {})
                    server.on_attach = on_attach
                    require("lspconfig")[server_name].setup(server)
                end,
            },
        })


        -- dart ls comes preinstalled with flutter. Not found in mason
        require("lspconfig")["dartls"].setup({})

        -- print pyright diagnostics
        local publish_diagnostics = vim.lsp.handlers["textDocument/publishDiagnostics"]
        vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(function(error, result, context, config)
            local filtered_msgs = {}
            local unallowed_pyright_codes = {"reportUnusedVariable", "reportUnknownVariableType", "reportMissingImports"}
            for _, msg in ipairs(result.diagnostics) do
                if (
                    msg.source == "Pyright" and
                    vim.tbl_contains(unallowed_pyright_codes, msg.code)
                ) then
                    -- print(string.format("Ignored: %s: %s", tostring(msg.code), tostring(msg.message)))
                    -- print used before was blocking
                    vim.notify(
                        string.format("Ignored: %s: %s", tostring(msg.code), tostring(msg.message)),
                        vim.log.levels.INFO
                    )
                else
                    table.insert(filtered_msgs, msg)
                end
            end
            result.diagnostics = filtered_msgs
            return publish_diagnostics(error, result, context, config)
        end, {})

        -- change diagnostic symbols in the sign column (gutter)
        local signs = { Error = " ", Warn = " ", Hint = " ", Info = " " }
        for type, icon in pairs(signs) do
            local hl = "DiagnosticSign" .. type
            vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
        end

        vim.keymap.set("n", "<leader>rl", "<cmd>LspRestart<cr>")
    end,
}
