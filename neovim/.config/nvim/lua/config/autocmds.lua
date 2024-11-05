-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- delete trailing white space on save
-- https://vi.stackexchange.com/a/41388/52938
vim.api.nvim_create_autocmd({ "BufWritePre" }, {
  pattern = { "*" },
  ---@diagnostic disable-next-line: unused-local
  callback = function(ev)
    local save_cursor = vim.fn.getpos(".")
    vim.cmd([[%s/\s\+$//e]])
    vim.fn.setpos(".", save_cursor)
  end,
})
