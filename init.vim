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

call plug#end()

" ----------------------------
" LSP Key Mappings (ADD THIS SECTION)
" ----------------------------
" These mappings work when LSP is attached to a buffer
nnoremap <silent> gd <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gD <cmd>lua vim.lsp.buf.declaration()<CR>
nnoremap <silent> gr <cmd>lua vim.lsp.buf.references()<CR>
nnoremap <silent> gi <cmd>lua vim.lsp.buf.implementation()<CR>
nnoremap <silent> K <cmd>lua vim.lsp.buf.hover()<CR>
nnoremap <silent> <C-k> <cmd>lua vim.lsp.buf.signature_help()<CR>
nnoremap <silent> <space>rn <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> <space>ca <cmd>lua vim.lsp.buf.code_action()<CR>
nnoremap <silent> <space>f <cmd>lua vim.lsp.buf.formatting()<CR>

" Try Ctrl+Click (may not work in all terminals)
nnoremap <silent> <C-LeftMouse> <cmd>lua vim.lsp.buf.definition()<CR>
inoremap <silent> <C-LeftMouse> <cmd>lua vim.lsp.buf.definition()<CR>

" Alternative: Use g<LeftMouse> if Ctrl+Click doesn't work
nnoremap <silent> g<LeftMouse> <cmd>lua vim.lsp.buf.definition()<CR>

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
-- LSP and Completion setup
local ok_lsp, lspconfig = pcall(require, "lspconfig")
local ok_cmp, cmp = pcall(require, "cmp")
local ok_snip, luasnip = pcall(require, "luasnip")
local ok_capabilities, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")

if not (ok_lsp and ok_cmp and ok_snip and ok_capabilities) then
  print("Some LSP plugins failed to load")
  return
end

-- Setup capabilities with autocompletion
local capabilities = cmp_nvim_lsp.default_capabilities()

-- Auto-format on save (optional but useful)
vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function()
    vim.lsp.buf.format({ async = false })
  end,
})

-- Show diagnostics in hover window
vim.diagnostic.config({
  virtual_text = true,
  signs = true,
  update_in_insert = false,
})

-- Key mappings for diagnostics
vim.keymap.set('n', '[d', vim.diagnostic.goto_prev, { desc = "Go to previous diagnostic" })
vim.keymap.set('n', ']d', vim.diagnostic.goto_next, { desc = "Go to next diagnostic" })
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float, { desc = "Open diagnostic float" })
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist, { desc = "Set location list" })

-- Setup common language servers
-- Uncomment and configure based on your needs:

-- For Python
-- lspconfig.pyright.setup({ capabilities = capabilities })
-- Or use pylsp:
-- lspconfig.pylsp.setup({ capabilities = capabilities })

-- For JavaScript/TypeScript
-- lspconfig.tsserver.setup({ capabilities = capabilities })

-- For Go
-- lspconfig.gopls.setup({ capabilities = capabilities })

-- For Rust
-- lspconfig.rust_analyzer.setup({ capabilities = capabilities })

-- For C/C++ (you already have this)
lspconfig.clangd.setup({
  capabilities = capabilities,
  cmd = { "clangd", "--background-index", "--clang-tidy", "--header-insertion=iwyu" },
})

-- For Lua (useful for Neovim config)
lspconfig.lua_ls.setup({
  capabilities = capabilities,
  settings = {
    Lua = {
      runtime = { version = 'LuaJIT' },
      diagnostics = { globals = { 'vim' } },
      workspace = { library = vim.api.nvim_get_runtime_file("", true) },
      telemetry = { enable = false },
    },
  },
})

-- Autocompletion setup
cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { "i", "s" }),
    ["<S-Tab>"] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { "i", "s" }),
  }),
  sources = cmp.config.sources({
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  }),
})

-- Set up luasnip
require("luasnip.loaders.from_vscode").lazy_load()
EOF

" ----------------------------
" Additional Settings (ADD THIS)
" ----------------------------
" Make sure LSP is working
autocmd FileType python,c,cpp,java,javascript,typescript,lua setlocal omnifunc=v:lua.vim.lsp.omnifunc

" Highlight references when cursor is on a symbol
autocmd CursorHold * silent! lua vim.lsp.buf.document_highlight()
autocmd CursorMoved * silent! lua vim.lsp.buf.clear_references()

" Enhanced type checking shortcuts
nnoremap <silent> <leader>t <cmd>lua vim.lsp.buf.hover()<CR>
inoremap <silent> <C-t> <cmd>lua vim.lsp.buf.hover()<CR>

" Show type in status line
autocmd CursorHold * silent! lua vim.lsp.buf.hover({ focusable = false })
