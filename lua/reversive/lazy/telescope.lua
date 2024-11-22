
return {
    {
        "nvim-telescope/telescope.nvim",
        dependencies = {
            "nvim-lua/plenary.nvim"
        },
        config = function()
            local keymap = vim.keymap
            local builtin = require('telescope.builtin')
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

            keymap.set('n', '<leader>pf', builtin.find_files, {})
            keymap.set('n', '<C-p>', builtin.git_files, {})
            keymap.set('n', '<leader>ps', function()
                builtin.grep_string({ search = vim.fn.input("Grep > ") })
            end) 
        end,
    },
}
