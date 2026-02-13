-- Only required if you have packer configured as `opt`
vim.cmd [[packadd packer.nvim]]

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  use {
	'nvim-telescope/telescope.nvim', tag = '0.1.6',
	requires = { { 'nvim-lua/plenary.nvim' } }
  }

  use {
	'rose-pine/neovim',
	as = 'rose-pine',
	config = function()
		vim.cmd('colorscheme rose-pine')
	end
  }

  use ('nvim-treesitter/nvim-treesitter', {run = ':TSUpdate'})
  
  use ('theprimeagen/harpoon')

  use ('mbbill/undotree')

  use ('tpope/vim-fugitive')

  use {
	'VonHeikemen/lsp-zero.nvim',
	requires = {
		{'neovim/nvim-lspconfig'},
		{'williamboman/mason.nvim'},
		{'williamboman/mason-lspconfig.nvim'},

		{'hrsh7th/nvim-cmp'},
		{'hrsh7th/cmp-buffer'},
		{'hrsh7th/cmp-path'},
		{'saadparwaiz1/cmp_luasnip'},
		{'hrsh7th/cmp-nvim-lsp'},
		{'hrsh7th/cmp-nvim-lua'},

		{'L3MON4D3/LuaSnip'},
		{'rafamadriz/friendly-snippets'},
	}
  }

  use {
    'preservim/nerdtree'
  }


  use({
    "mfussenegger/nvim-dap",
  })

use({
  "rcarriga/nvim-dap-ui",
  requires = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
})

use({
  "theHamsta/nvim-dap-virtual-text",
  requires = { "mfussenegger/nvim-dap" },
})

-- Optional: For better debugging experience with Mason
use({
  "jay-babu/mason-nvim-dap.nvim",
  requires = {
    "williamboman/mason.nvim",
    "mfussenegger/nvim-dap",
  },
})


end)
