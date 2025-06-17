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
                "gopls",
                "ts_ls",
                "biome",
            },
            handlers = {
                -- Default handler with shared on_attach
                function(server_name)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            -- Common keymaps for all servers
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

                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
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

                            if client.supports_method("textDocument/formatting") then
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    group = vim.api.nvim_create_augroup("ClangdFormatOnSave", { clear = true }),
                                    buffer = bufnr,
                                    callback = function() vim.lsp.buf.format({ async = false, bufnr = bufnr }) end,
                                })
                            end
                        end
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                },
                                workspace = {
                                    library = vim.api.nvim_get_runtime_file("", true),
                                    checkThirdParty = false,
                                },
                                telemetry = { enable = false },
                            }
                        }
                    }
                end,

                ["gopls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
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

                            if client.supports_method("textDocument/formatting") then
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    group = vim.api.nvim_create_augroup("GoFormatOnSave", { clear = true }),
                                    buffer = bufnr,
                                    callback = function() vim.lsp.buf.format({ async = false, bufnr = bufnr }) end,
                                })
                            end
                        end,
                        settings = {
                            gopls = {
                                gofumpt = true,
                            },
                        },
                    }
                end,

                ["ts_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.ts_ls.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
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
                            vim.keymap.set('n', '<space>o', '<cmd>TSToolsOrganizeImports<CR>', opts)
                            vim.keymap.set('n', '<space>ru', '<cmd>TSToolsRemoveUnusedImports<CR>', opts)

                            if client.supports_method("textDocument/formatting") then
                                vim.api.nvim_create_autocmd("BufWritePre", {
                                    group = vim.api.nvim_create_augroup("TSFormatOnSave", { clear = true }),
                                    buffer = bufnr,
                                    callback = function()
                                        vim.lsp.buf.format({ async = false, bufnr = bufnr })
                                    end,
                                })
                            end
                        end,
                        settings = {
                            typescript = {
                                format = {
                                    enable = true,
                                },
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
                                format = {
                                    enable = true,
                                },
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
                ["biome"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.biome.setup {
                        capabilities = capabilities,
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
            -- Add completion window configuration for better visibility
            window = {
                completion = cmp.config.window.bordered(),
                documentation = cmp.config.window.bordered(),
            },
            -- Ensure completion shows even for single character
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
