return {
    {
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
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
                timeout_ms = 3000,
                lsp_fallback = true,
            },
        },
    },
}
