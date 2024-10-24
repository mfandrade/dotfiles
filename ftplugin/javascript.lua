-- Create a mapping in insert mode
-- https://stackoverflow.com/questions/7187477/vim-smart-insert-semicolon
vim.api.nvim_set_keymap("i", "<Space><CR>", "<END>;<CR>", { noremap = true, silent = true })
