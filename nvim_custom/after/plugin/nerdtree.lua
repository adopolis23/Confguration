-- ~/.config/nvim/lua/config/nerdtree.lua or add to init.lua
local vim = vim
local g = vim.g

-- NERDTree settings
g.NERDTreeShowHidden = 1
g.NERDTreeMinimalUI = 1
g.NERDTreeAutoDeleteBuffer = 1
g.NERDTreeQuitOnOpen = 0
g.NERDTreeShowLineNumbers = 1
g.NERDTreeIgnore = { '%.pyc$', '__pycache__', '%.swp$', '%.bak$', '%.class$', 'node_modules' }
g.NERDTreeShowBookmarks = 1
g.NERDTreeMouseMode = 2
g.NERDTreeChDirMode = 2  -- Change CWD to NERDTree root

-- Key mappings
vim.api.nvim_set_keymap('n', '<leader>n', ':NERDTreeToggle<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>f', ':NERDTreeFind<CR>', { noremap = true, silent = true })

-- Auto close NERDTree when it's the last window
vim.cmd([[
  autocmd BufEnter * if (winnr("$") == 1 && exists("b:NERDTree") && b:NERDTree.isTabTree()) | q | endif
]])

-- Optional: Auto open NERDTree when opening a directory
vim.cmd([[
  autocmd StdinReadPre * let s:std_in=1
  autocmd VimEnter * if argc() == 1 && isdirectory(argv()[0]) && !exists("s:std_in") | exe 'NERDTree' argv()[0] | wincmd p | ene | exe 'cd '.argv()[0] | endif
]])

-- Optional: Close NERDTree after opening a file
vim.cmd([[
  autocmd BufEnter * if winnr('$') == 1 && exists('b:NERDTree') && b:NERDTree.isTabTree() | quit | endif
]])
