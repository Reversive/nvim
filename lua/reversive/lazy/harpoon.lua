return {
    {
        "ThePrimeagen/harpoon",
        branch = "harpoon2",
        dependencies = { "nvim-lua/plenary.nvim" },
        keys = {
            { "<leader>a", function() require("harpoon"):list():add() end, desc = "Add file to harpoon" },
            { "<C-e>", function() require("harpoon").ui:toggle_quick_menu(require("harpoon"):list()) end, desc = "Toggle harpoon menu" },
            { "<leader>1", function() require("harpoon"):list():select(1) end, desc = "Harpoon file 1" },
            { "<leader>2", function() require("harpoon"):list():select(2) end, desc = "Harpoon file 2" },
            { "<leader>3", function() require("harpoon"):list():select(3) end, desc = "Harpoon file 3" },
            { "<leader>4", function() require("harpoon"):list():select(4) end, desc = "Harpoon file 4" },
            { "<Tab>", function() require("harpoon"):list():next() end, desc = "Next harpoon file" },
            { "<S-Tab>", function() require("harpoon"):list():prev() end, desc = "Previous harpoon file" },
        },
        config = function()
            local harpoon = require("harpoon")
            harpoon:setup()
        end,
    },
}
