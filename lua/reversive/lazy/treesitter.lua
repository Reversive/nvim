return {
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        config = function()
            local configs = require("nvim-treesitter.configs")

            configs.setup({
                ensure_installed = { 
                    "vimdoc", "javascript", "typescript", 
                    "c", "lua", "rust", "jsdoc", "bash", "cpp"
                },
                sync_install = false,
                auto_install = true,
                indent = {
                    enable = true
                },
                highlight = {
                    enable = true
                },
            })
        end
    },
}
