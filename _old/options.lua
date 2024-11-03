-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Don't sync clipboard with system
vim.opt.clipboard = ""

-- https://vi.stackexchange.com/a/33059
vim.cmd("hi LineNrAbove guifg=cyan ctermfg=cyan")
vim.cmd("hi LineNrBelow guifg=red ctermfg=red")

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

-- https://github.com/christoomey/vim-tmux-navigator/#disable-wrapping
vim.g.tmux_navigator_no_wrap = 1
-- vim.g.tmux_navigator_disable_when_zoomed = 1
-- vim.g.tmux_navigator_preserve_zoom = 1

vim.cmd("set scrolloff=10")

-- show an indicator in statusline for file not saved
vim.opt.modified = true
vim.opt.title = true
vim.opt.titlestring = "%f%m"
