-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here
local opts = { noremap = true, silent = true }

-- C-s to save
-- https://stackoverflow.com/a/77783955/2075
vim.keymap.set(
  { "n", "i" },
  "<C-s>",
  "<ESC>:w<ENTER>:echo 'File saved'<ENTER>",
  { noremap = true, silent = true, desc = "Save file" }
)

-- copy to system clipboard with Y
-- https://stackoverflow.com/a/67890
vim.keymap.set({ "n", "v" }, "Y", '"+y', opts)
vim.keymap.set("n", "yY", '^"+y$', opts)

-- don't yank the chars deleted with x
vim.keymap.set("n", "x", '"_x', opts)

-- and so, X delete the whole line
vim.keymap.set("n", "X", '^"_d$', opts)

-- select all
vim.keymap.set("n", "<C-a>", "ggVG", opts)

-- inc/decrement
vim.keymap.set("n", "+", "<C-a>", opts)
vim.keymap.set("n", "-", "<C-x>", opts)
