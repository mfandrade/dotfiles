-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Don't sync vim clipboard with the system
vim.opt.clipboard = ""

-- up to 10 lines of context always
vim.cmd("set scrolloff=10")

-- tilde is much more an operator
vim.cmd("set tildeop")

-- my choice for invisible chars
vim.opt.showbreak = "↪"
vim.opt.listchars = {
  tab = "»-",
  eol = "↲",
  nbsp = "•",
  trail = "█",
  precedes = "⟨",
  extends = "⟩",
}

-- avoid circling panes in tmux navigator
-- https://github.com/christoomey/vim-tmux-navigator/#disable-wr
vim.g.tmux_navigator_no_wrap = 1
-- vim.g.tmux_navigator_disable_when_zoomed = 1
-- vim.g.tmux_navigator_preserve_zoom = 1
