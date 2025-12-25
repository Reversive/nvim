return {
    {
        'akinsho/toggleterm.nvim',
        version = "*",
        cmd = "ToggleTerm",
        keys = {
            { [[<C-\>]], '<cmd>exe v:count1 . "ToggleTerm"<CR>', mode = { "n", "i" }, desc = "Toggle terminal" },
        },
        config = true,
    },
}
