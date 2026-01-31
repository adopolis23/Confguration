" ----------------------------
" Basic Settings
" ----------------------------
set number              " Show absolute line numbers
set relativenumber      " Show relative line numbers
set tabstop=4           " Number of spaces that a <Tab> counts for
set shiftwidth=4        " Number of spaces to use for autoindent
set expandtab           " Use spaces instead of tabs
set cursorline          " Highlight current line
set ignorecase          " Case insensitive search
set smartcase           " Except when using capital letters
set clipboard=unnamedplus " Use system clipboard
set nocursorline        " Remove the cursor under the selected line

" ----------------------------
" Plugins using vim-plug
" ----------------------------
call plug#begin('~/.local/share/nvim/plugged')

" File explorer
Plug 'preservim/nerdtree'

" Statusline
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'

" Syntax highlighting
Plug 'sheerun/vim-polyglot'

" Git integration
Plug 'tpope/vim-fugitive'

" IntelliSense
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'L3MON4D3/LuaSnip'
Plug 'saadparwaiz1/cmp_luasnip'

Plug 'frazrepo/vim-rainbow'

let g:rainbow_active = 1 " Enable globally
" Or just for specific filetypes:
" let g:rainbow_active = 0
" autocmd FileType c,cpp,js,python RainbowToggleOn

call plug#end()

" ----------------------------
" NERDTree settings
" ----------------------------
map <C-n> :NERDTreeToggle<CR> " Ctrl+n to toggle NERDTree
autocmd vimenter * NERDTree   " Open NERDTree on startup if no file given

" ----------------------------
" Airline settings
" ----------------------------
let g:airline#extensions#tabline#enabled = 1

lua << EOF
local ok_lsp, lspconfig = pcall(require, "lspconfig")
local ok_cmp, cmp = pcall(require, "cmp")
local ok_snip, luasnip = pcall(require, "luasnip")

if not (ok_lsp and ok_cmp and ok_snip) then
  return
end

lspconfig.clangd.setup({
  capabilities = require("cmp_nvim_lsp").default_capabilities(),
})

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "buffer" },
    { name = "path" },
  },
})
EOF
