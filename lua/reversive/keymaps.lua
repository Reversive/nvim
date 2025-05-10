local keymap = vim.keymap

vim.g.mapleader = " "
keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float)
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")
vim.keymap.set("x", "<leader>p", [["_dP]])
vim.keymap.set({ "n", "v" }, "<leader>y", [["+y]])
vim.keymap.set("n", "<leader>Y", [["+Y]])
vim.keymap.set({ "n", "v" }, "<leader>d", "\"_d")
vim.keymap.set("i", [[<C-\>]], '<cmd>exe v:count1 . "ToggleTerm"<CR>')
vim.keymap.set("n", [[<C-\>]], '<cmd>exe v:count1 . "ToggleTerm"<CR>')
vim.keymap.set("t", '<esc>', [[<C-\><C-n>]])
vim.keymap.set("t", '<C-k>', [[<C-\><C-n><C-W>k]])
