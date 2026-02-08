-- First, setup and configure Telescope
require('telescope').setup({
  defaults = {
    preview = {
      treesitter = false,  -- Disable Tree-sitter in preview to fix the error
    },
    file_ignore_patterns = { "node_modules", ".git" },
  },
})

-- Then load the builtin module
local builtin = require('telescope.builtin')

-- Your keymaps
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
    builtin.grep_string({ search = vim.fn.input("Grep > ") })
end)
