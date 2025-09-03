local clear=function(g) pcall(vim.api.nvim_set_hl,0,g,{bg="none"}) end
for _,g in ipairs({
  "Normal","NormalNC","NormalFloat","SignColumn","FoldColumn",
  "LineNr","CursorLine","CursorLineNr","EndOfBuffer","WinSeparator",
  "Pmenu","PmenuSel","FloatBorder","TelescopeNormal","TelescopeBorder"
}) do clear(g) end
local set=function(g,o) pcall(vim.api.nvim_set_hl,0,g,o) end
set("Comment",{fg="#484951"})
set("@comment",{fg="#484951"})
set("TSComment",{fg="#484951"})
-- TTY_BLACK_BG_START
if not vim.opt.termguicolors:get() then
  -- 256-colour fallback for comments
  vim.cmd([[highlight! default Comment ctermfg=239]])
  vim.cmd([[highlight! link @comment Comment]])
  vim.cmd([[highlight! link TSComment Comment]])

  -- Force black backgrounds in TTY (cterm index 0)
  vim.cmd([[
    highlight Normal        ctermbg=0
    highlight NormalNC      ctermbg=0
    highlight NormalFloat   ctermbg=0
    highlight SignColumn    ctermbg=0
    highlight FoldColumn    ctermbg=0
    highlight LineNr        ctermbg=0
    highlight CursorLine    ctermbg=0
    highlight CursorLineNr  ctermbg=0
    highlight EndOfBuffer   ctermbg=0
    highlight StatusLine    ctermbg=0
    highlight Pmenu         ctermbg=0
    highlight PmenuSel      ctermbg=0
    highlight FloatBorder   ctermbg=0
  ]])
end
-- TTY_BLACK_BG_END
