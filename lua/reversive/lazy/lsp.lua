return {
    "neovim/nvim-lspconfig",
    dependencies = {
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-cmdline",
        "hrsh7th/nvim-cmp",
        "L3MON4D3/LuaSnip",
        "saadparwaiz1/cmp_luasnip",
        "j-hui/fidget.nvim",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_lsp = require("cmp_nvim_lsp")
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities()
        )
        require("fidget").setup({})
        require("mason").setup()
        require("mason-lspconfig").setup({
            ensure_installed = {
                "lua_ls",
                "rust_analyzer",
                "clangd",
                "ts_ls",
                "eslint"
            },
            handlers = {
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = function(_, bufnr)
                            local opts = { buffer = bufnr, noremap = true, silent = true }
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wl', function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, opts)
                            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                        end
                    }
                end,
                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            local opts = { buffer = bufnr, noremap = true, silent = true }
                            client.server_capabilities.documentFormattingProvider = false
                            client.server_capabilities.documentRangeFormattingProvider = false
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
                            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wl', function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, opts)
                            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                            vim.keymap.set('n', '<space>o', '<cmd>TSToolsOrganizeImports<CR>', opts)
                            vim.keymap.set('n', '<space>ru', '<cmd>TSToolsRemoveUnusedImports<CR>', opts)
                        end,
                        settings = {
                            typescript = {
                                preferences = {
                                    importModuleSpecifierPreference = "non-relative",
                                },
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayVariableTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                },
                            },
                            javascript = {
                                preferences = {
                                    importModuleSpecifierPreference = "non-relative",
                                },
                                inlayHints = {
                                    includeInlayParameterNameHints = "all",
                                    includeInlayVariableTypeHints = true,
                                    includeInlayFunctionLikeReturnTypeHints = true,
                                    includeInlayEnumMemberValueHints = true,
                                },
                            },
                        },
                        root_dir = lspconfig.util.root_pattern("tsconfig.json", "package.json", "jsconfig.json", ".git"),
                    }
                end,
                ["eslint"] = function()
                    require("lspconfig").eslint.setup {
                        capabilities = capabilities,
                        on_attach = function(_, bufnr)
                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.format {
                                        filter = function(c)
                                            return c.name == "eslint"
                                        end,
                                        bufnr = bufnr,
                                        async = true,
                                    }
                                end,
                            })
                        end,
                    }
                end,
            }
        })
        local cmp_select = { behavior = cmp.SelectBehavior.Select }
        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body)
                end,
            },
            mapping = cmp.mapping.preset.insert({
                ['<C-j>'] = cmp.mapping.select_next_item(cmp_select),
                ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select),
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ['<C-e>'] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }),
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
                { name = 'path' },
            }),
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            completion = {
                completeopt = 'menu,menuone,noinsert'
            },
        })
        vim.diagnostic.config({
            virtual_text = true,
            signs = true,
            underline = true,
            update_in_insert = false,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        })
    end
}
