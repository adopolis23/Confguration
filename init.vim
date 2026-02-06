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

Plug 'mfussenegger/nvim-dap'
Plug 'rcarriga/nvim-dap-ui'
Plug 'theHamsta/nvim-dap-virtual-text'
Plug 'nvim-telescope/telescope-dap.nvim'

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
--vim.api.nvim_create_autocmd("BufWritePre", {
  --callback = function()
    --vim.lsp.buf.format({ async = false })
  --end,
--})

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

-- DAP Configuration
local dap = require('dap')

-- Configure GDB adapter
dap.adapters.gdb = {
  type = "executable",
  command = "gdb",
  args = { "-i", "dap" }
}

-- C Debug Configurations
dap.configurations.c = {
  {
    name = "Launch (GDB)",
    type = "gdb",
    request = "launch",
    program = function()
      -- Try to find the executable automatically
      local filename = vim.fn.expand('%:p:r')  -- Remove extension
      
      -- Check for common executable names
      if vim.fn.executable(filename) == 1 then
        return filename
      elseif vim.fn.executable(filename .. '.out') == 1 then
        return filename .. '.out'
      elseif vim.fn.executable(filename .. '.exe') == 1 then
        return filename .. '.exe'
      elseif vim.fn.executable('a.out') == 1 then
        return 'a.out'
      elseif vim.fn.executable('./main') == 1 then
        return './main'
      else
        -- Ask user if not found
        return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
      end
    end,
    cwd = "${workspaceFolder}",
    stopAtBeginningOfMainSubprogram = false,
    args = {},
    runInTerminal = false,
  },
  {
    name = "Launch with args",
    type = "gdb",
    request = "launch",
    program = function()
      return vim.fn.input('Path to executable: ', vim.fn.getcwd() .. '/', 'file')
    end,
    args = function()
      local input = vim.fn.input('Program arguments: ')
      return vim.split(input, " ", true)
    end,
  },
  {
    name = "Attach to process",
    type = "gdb",
    request = "attach",
    processId = function()
      return vim.fn.input('Process ID: ', '')
    end,
  }
}

-- Copy configurations for C++ (same as C)
dap.configurations.cpp = dap.configurations.c

-- Optional: DAP UI setup (if you installed nvim-dap-ui)
local dapui_ok, dapui = pcall(require, 'dapui')
if dapui_ok then
  dapui.setup()
  
  -- Auto open/close UI
  dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
  end
  dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
  end
  dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
  end
end

-- Optional: Virtual text (if you installed nvim-dap-virtual-text)
local virt_ok, virt = pcall(require, 'nvim-dap-virtual-text')
if virt_ok then
  virt.setup()
end

print("DAP configured for C/C++ debugging")
EOF


" ----------------------------
" Debugging Commands & Mappings
" ----------------------------
" Start debugging with F5
nnoremap <silent> <F5> :lua require('dap').continue()<CR>

" Set breakpoint with F9
nnoremap <silent> <F9> :lua require('dap').toggle_breakpoint()<CR>

" Step commands
nnoremap <silent> <F10> :lua require('dap').step_over()<CR>
nnoremap <silent> <F11> :lua require('dap').step_into()<CR>
nnoremap <silent> <F12> :lua require('dap').step_out()<CR>

" Debug commands
nnoremap <leader>dc :lua require('dap').continue()<CR>
nnoremap <leader>db :lua require('dap').toggle_breakpoint()<CR>
nnoremap <leader>dB :lua require('dap').set_breakpoint(vim.fn.input('Condition: '))<CR>
nnoremap <leader>dr :lua require('dap').repl.open()<CR>
nnoremap <leader>dt :lua require('dap').terminate()<CR>
nnoremap <leader>dp :lua require('dap').pause()<CR>

" Quick debug current file
nnoremap <leader>dd :lua
  \ local dap = require('dap')
  \ local config = {
  \   name = 'Debug Current',
  \   type = 'gdb',
  \   request = 'launch',
  \   program = vim.fn.expand('%:p:r'),
  \   cwd = vim.fn.getcwd(),
  \   args = {},
  \ }
  \ dap.run(config)

" Compile and debug command
command! -nargs=* CDebug call CompileAndDebug(<q-args>)
function! CompileAndDebug(args)
  let source = expand('%:p')
  let output = expand('%:p:r')
  
  " Compile with debug symbols
  echo "Compiling with debug symbols..."
  let compile_cmd = 'gcc -g -o ' . shellescape(output) . ' ' . shellescape(source) . ' ' . a:args
  let result = system(compile_cmd)
  
  if v:shell_error != 0
    echo "Compilation failed:"
    echo result
    return
  endif
  
  echo "Compilation successful. Starting debugger..."
  
  " Start debugging
  lua << EOF
  local dap = require('dap')
  dap.run({
    name = 'Debug',
    type = 'gdb',
    request = 'launch',
    program = vim.fn.expand('%:p:r'),
    cwd = vim.fn.getcwd(),
    args = {},
  })
EOF
endfunction




