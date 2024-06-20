lvim.plugins = {
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
  {
    "folke/trouble.nvim",
    opts = {}
  }
}

lvim.colorscheme = "catppuccin-mocha"

-- Installed binaries are not compatible with NixOS
lvim.lsp.installer.setup.automatic_installation = false

require'lspconfig'.taplo.setup{}

-- Keybindings
lvim.keys.normal_mode["H"] = "<cmd>BufferLineCyclePrev<cr>"
lvim.keys.normal_mode["L"] = "<cmd>BufferLineCycleNext<cr>"
lvim.builtin.which_key.mappings["x"] = {
  name = "Trouble",
  x = {
    "<cmd>Trouble diagnostics toggle<cr>",
    "Diagnostics (Trouble)",
  },
  X = {
    "<cmd>Trouble diagnostics toggle filter.buf=0<cr>",
    "Buffer Diagnostics (Trouble)",
  },
  s = {
    "<cmd>Trouble symbols toggle focus=false<cr>",
    "Symbols (Trouble)",
  },
  l = {
    "<cmd>Trouble lsp toggle focus=false win.position=right<cr>",
    "LSP Definitions / references / ... (Trouble)",
  },
  L = {
    "<cmd>Trouble loclist toggle<cr>",
    "Location List (Trouble)",
  },
  q = {
    "<cmd>Trouble qflist toggle<cr>",
    "Quickfix List (Trouble)",
  },

}

-- Linters and formatters
local formatters = require "lvim.lsp.null-ls.formatters"
formatters.setup {
  { name = "prettierd" },
  { name = "nixfmt" },
  { name = "cmake_format" },
}

local linters = require "lvim.lsp.null-ls.linters"
linters.setup {
}

-- CPS syntax highlighting
local cps_autocommand = {
  pattern = { "*.cps" },
  command = "setfiletype cps"
}
lvim.autocommands = {
  {
    "BufEnter", cps_autocommand
  },
  {
    "BufRead", cps_autocommand
  }
}
vim.treesitter.language.register('json', 'cps')
