-- Neovim
-- Options
vim.opt.number = true
vim.opt.relativenumber = true
vim.opt.wrap = true
vim.opt.linebreak = true
vim.opt.cursorline = true
vim.opt.cursorcolumn = true

-- Blinking Cursor
vim.opt.guicursor = "n-v-c-i:block-blinkon1"

-- Netrw
vim.keymap.set('n', '<C-e>', ':Lexplore<CR>', { noremap = true, silent = true })

-- Buffer navigation
vim.keymap.set('n', '<C-n>', ':bnext<CR>', { noremap = true, silent = true })
vim.keymap.set('n', '<C-p>', ':bprev<CR>', { noremap = true, silent = true })

-- Delete buffer without closing window
vim.keymap.set('n', '<leader>bd', ':bp<bar>sp<bar>bn<bar>bd<CR>', { noremap = true, silent = true })

-- Save and delete buffer (like :wq but keeps window)
vim.keymap.set('n', '<leader>wq', ':w<CR>:bp<bar>sp<bar>bn<bar>bd<CR>', { noremap = true, silent = true })

vim.g.netrw_winsize = 10
vim.g.netrw_banner = 0
vim.g.netrw_browse_split = 0
vim.g.netrw_altv = 1

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

-- StatusLine Colors
vim.cmd([[
  highlight StatusLine ctermfg=244 ctermbg=0 guifg=#808080 guibg=#000000
  highlight StatusLineNC ctermfg=244 ctermbg=0 guifg=#808080 guibg=#000000
]])

-- Apply immediately
vim.opt.pumblend = 10
vim.opt.winblend = 10

-- LSP Keybindings
vim.keymap.set('n', 'gd', vim.lsp.buf.definition, { desc = 'Go to definition' })
vim.keymap.set('n', 'K', vim.lsp.buf.hover, { desc = 'Hover documentation' })
vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, { desc = 'Rename symbol' })
vim.keymap.set('n', '<leader>ca', vim.lsp.buf.code_action, { desc = 'Code action' })
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = 'Previous diagnostic' })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = 'Next diagnostic' })
