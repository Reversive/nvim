--return {}
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
                "gopls", -- Added gopls here
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup {
                        capabilities = capabilities
                    }
                end,

                ["clangd"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.clangd.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr) -- Changed client to _ as it's not used
                            -- Enable completion triggered by <c-x><c-o>
                            -- vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc') (already handled by capabilities)

                            -- Mappings.
                            -- See `:help vim.lsp.*` for documentation on any of the below functions
                            local opts = { buffer = bufnr, noremap = true, silent = true }
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- Using <C-k> for signature_help as it's common
                            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wl', function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, opts)
                            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)

                            vim.api.nvim_create_autocmd("BufWritePre", {
                                buffer = bufnr,
                                callback = function()
                                    vim.lsp.buf.format({ async = false })
                                end,
                            })
                        end
                    }
                end,

                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        -- on_attach = function(client, bufnr) end, -- You can add on_attach for lua_ls here if needed
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" }, -- Assuming Neovim's LuaJIT, which is 5.1 compatible
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                                -- workspace = { library = vim.api.nvim_get_runtime_file("", true) }, -- Consider adding this for better stdlib completion
                                -- telemetry = { enable = false },
                            }
                        }
                    }
                end,

                ["gopls"] = function() -- Handler for gopls
                    local lspconfig = require("lspconfig")
                    lspconfig.gopls.setup {
                        capabilities = capabilities,
                        on_attach = function(client, bufnr)
                            -- Common LSP keybindings.
                            -- See `:help vim.lsp.*` and `:help vim.keymap.set()`
                            -- You can add more or modify these to your liking.
                            local opts = { buffer = bufnr, noremap = true, silent = true }
                            vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
                            vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
                            vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
                            vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts) -- Or another keybinding if <C-k> conflicts with cmp
                            vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
                            vim.keymap.set('n', '<space>wl', function()
                                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
                            end, opts)
                            vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
                            vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
                            vim.keymap.set({ 'n', 'v' }, '<space>ca', vim.lsp.buf.code_action, opts)
                            vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
                            -- Formatting on save (optional, gopls usually handles this well, or you can use a dedicated formatting plugin)
                            -- if client.supports_method("textDocument/formatting") then
                            --   vim.api.nvim_create_autocmd("BufWritePre", {
                            --     group = vim.api.nvim_create_augroup("GoFormatOnSave", { clear = true }),
                            --     buffer = bufnr,
                            --     callback = function() vim.lsp.buf.format({ async = false, bufnr = bufnr }) end,
                            --   })
                            -- end

                            -- You can add gopls specific commands here if needed
                            -- For example, to run goimports:
                            -- vim.keymap.set('n', '<leader>i', '<cmd>lua vim.lsp.buf.execute_command({ command = "gopls.goimports", arguments = { vim.api.nvim_buf_get_name(0) } })<CR>', opts)
                        end,
                        settings = {
                            gopls = {
                                -- Example settings for gopls:
                                -- analyses = {
                                --   unusedparams = true,
                                -- },
                                -- staticcheck = true,
                                -- gofumpt = true, -- if you prefer gofumpt for formatting
                                -- Complete list: https://github.com/golang/tools/blob/master/gopls/doc/settings.md
                            },
                        },
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
                ['<C-j>'] = cmp.mapping.select_next_item(cmp_select), -- Corrected to select_next_item for C-j (down)
                ['<C-k>'] = cmp.mapping.select_prev_item(cmp_select), -- Corrected to select_prev_item for C-k (up)
                ['<C-y>'] = cmp.mapping.confirm({ select = true }),
                ["<C-Space>"] = cmp.mapping.complete(),
                ['<CR>'] = cmp.mapping.confirm({ select = true }), -- Often useful to confirm with Enter too
            }),
            sources = cmp.config.sources({
                { name = 'nvim_lsp' },
                { name = 'luasnip' },
            }, {
                { name = 'buffer' },
                { name = 'path' }, -- Added path source
            }),
            -- Optional: Add cmdline completion sources
            -- cmp.setup.cmdline('/', {
            --   mapping = cmp.mapping.preset.cmdline(),
            --   sources = {
            --     { name = 'buffer' }
            --   }
            -- }),
            -- cmp.setup.cmdline(':', {
            --   mapping = cmp.mapping.preset.cmdline(),
            --   sources = cmp.config.sources({
            --     { name = 'path' }
            --   }, {
            --     { name = 'cmdline' }
            --   })
            -- })
        })

        vim.diagnostic.config({
            -- update_in_insert = true, -- Consider enabling if you want diagnostics while typing
            virtual_text = true, -- Enable virtual text for diagnostics
            signs = true,        -- Enable signs in the signcolumn
            underline = true,
            float = {
                focusable = false,
                style = "minimal",
                border = "rounded",
                source = "always", -- Or "if_many"
                header = "",
                prefix = "",
            },
        })

        -- Show diagnostic symbols in status line (requires a status line plugin that supports this)
        -- vim.cmd([[
        --   set statusline+=%#warningmsg#
        --   set statusline+=%* diagnostic#LinterWarning#%{len(vim.diagnostic.get(0, {'severity': vim.diagnostic.severity.WARN}))}
        --   set statusline+=%* diagnostic#LinterError#%{len(vim.diagnostic.get(0, {'severity': vim.diagnostic.severity.ERROR}))}
        -- ]])
    end
}
