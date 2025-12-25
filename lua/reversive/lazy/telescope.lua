return {
    {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        keys = {
            { "<leader>pf", function() require('telescope.builtin').find_files() end, desc = "Find files" },
            { "<C-p>", function() require('telescope.builtin').git_files() end, desc = "Git files" },
            { "<leader>ps", function()
                require('telescope.builtin').grep_string({ search = vim.fn.input("Grep > ") })
            end, desc = "Grep string" },
        },
        dependencies = {
            { "nvim-lua/plenary.nvim", lazy = true },
        },
        config = function()
            local actions = require('telescope.actions')
            require('telescope').setup({
                defaults = {
                    mappings = {
                        i = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                        n = {
                            ["<C-j>"] = actions.move_selection_next,
                            ["<C-k>"] = actions.move_selection_previous,
                        },
                    },
                },
            })
        end,
    },
}
