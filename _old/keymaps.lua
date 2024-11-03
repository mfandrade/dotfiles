-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- C-S to save file -- https://stackoverflow.com/a/77783955/2075507
vim.keymap.set(
  { "n" },
  "<C-s>",
  ":w<ENTER>:echo 'File saved'<ENTER>",
  { noremap = true, silent = true, desc = "Save file" }
)

-- Copy to clipboard with Y -- https://stackoverflow.com/a/67890119/2075507
-- nnoremap Y "+y
-- vnoremap Y "+y
-- nnoremap yY ^"+y$
vim.keymap.set({ "n" }, "Y", '"+y')
vim.keymap.set({ "v" }, "Y", '"+y')
vim.keymap.set({ "n" }, "yY", '^"+y$')

-- C-a to select all
-- vim.keymap.set("n", "C-a", "ggVG")

-- Remap increment and decrement operators
vim.keymap.set("n", "+", "<C-a>", { noremap = true, silent = true, desc = "Increment number" })
vim.keymap.set("n", "-", "<C-x>", { noremap = true, silent = true, desc = "Decrement number" }) -- 0x1
