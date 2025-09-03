-- Neovim
-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Blinking Cursor
vim.opt.guicursor = "n-v-c-i:ver25-blinkon1"

-- Netrw
vim.keymap.set('n', '<C-e>', ':Lexplore<CR>', { noremap = true, silent = true })
vim.g.netrw_winsize = 10
vim.g.netrw_banner = 0


-- Settings
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.tabstop = 4
vim.opt.smartindent = true
vim.opt.scrolloff = 10

-- Search
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- StatusLine
vim.opt.laststatus = 2

-- Force black background for all colorschemes

-- Also set it immediately for the current session
vim.opt.termguicolors = true
vim.cmd.colorscheme("default")

-- Apply immediately
vim.opt.pumblend = 10
vim.opt.winblend = 10
