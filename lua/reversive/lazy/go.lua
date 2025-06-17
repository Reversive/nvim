-- lua/reversive/lazy/go.lua
return {
    {
        "williamboman/mason.nvim",
        opts = function(_, opts)
            -- Ensure the ensure_installed table exists
            opts.ensure_installed = opts.ensure_installed or {}
            -- Add Go tools to the list
            vim.list_extend(opts.ensure_installed, {
                "gopls",
                "goimports",
                "golangci-lint",
            })
        end,
    },
    {
        "stevearc/conform.nvim",
        opts = {
            formatters_by_ft = {
                go = { "goimports" },
                javascript = { "biome" },
                typescript = { "biome" },
                javascriptreact = { "biome" },
                typescriptreact = { "biome" },
                json = { "biome" },
                jsonc = { "biome" },
            },
            format_on_save = {
                timeout_ms = 500,
                lsp_fallback = true, -- fallback to LSP formatting if conform fails
            },
        },
    },
}
