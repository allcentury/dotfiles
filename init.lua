local vim = _G.vim
vim.cmd('filetype plugin indent on')
vim.o.autoindent = true
vim.g.mapleader = ','
vim.o.expandtab = true  -- expand tab input with spaces characters
vim.o.smartindent = true -- syntax aware indentations for newline inserts
vim.o.tabstop = 2 -- num of space characters per tab
vim.o.shiftwidth = 2 -- spaces per indentation level
vim.wo.relativenumber = true

-- Ensure Ruby filetype is recognized
vim.api.nvim_exec([[
  au BufRead,BufNewFile *.rb set filetype=ruby
]], false)

local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  "folke/which-key.nvim",
  {
	  "folke/neoconf.nvim",
	  cmd = "Neoconf"
  },
  "neovim/nvim-lspconfig",
  'tpope/vim-fugitive',
  'tpope/vim-rhubarb',
  "nvim-tree/nvim-web-devicons",
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      -- calling `setup` is optional for customization
      require("fzf-lua").setup({})
    end
  },
  {
	  'numToStr/Comment.nvim',
	  opts = {
		  -- add any options here
	  },
	  lazy = false,
  },
  {
  "Mofiqul/dracula.nvim",
    config = function()
      vim.cmd("colorscheme dracula")
    end,
  },
  "github/copilot.vim",
  "nvim-treesitter/nvim-treesitter",
  {
	  "pmizio/typescript-tools.nvim",
	  dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
	  opts = {},
  },
  'vim-ruby/vim-ruby',
  { "folke/neodev.nvim", opts = {} },
  "preservim/vimux",
  "spiegela/vimix",
  "vim-test/vim-test",
  {
    'cameron-wags/rainbow_csv.nvim',
    config = true,
    ft = {
      'csv',
      'tsv',
      'csv_semicolon',
      'csv_whitespace',
      'csv_pipe',
      'rfc_csv',
      'rfc_semicolon'
    },
    cmd = {
      'RainbowDelim',
      'RainbowDelimSimple',
      'RainbowDelimQuoted',
      'RainbowMultiDelim'
    }
  },
  'rust-lang/rust.vim',
  'saecki/crates.nvim',
})

require('crates').setup()

require("neodev").setup({})
-- then setup your lsp server as usual
local nvim_lsp = require('lspconfig')

-- example to setup lua_ls and enable call snippets
nvim_lsp.lua_ls.setup({
  settings = {
    Lua = {
      completion = {
        callSnippet = "Replace"
      }
    }
  }
})


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(_client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Mappings.
  local opts = { noremap=true, silent=true }

  -- See `:help vim.lsp.*` for documentation on any of the below functions
  buf_set_keymap('n', 'gD', '<Cmd>lua vim.lsp.buf.declaration()<CR>', opts)
  buf_set_keymap('n', 'gd', '<Cmd>lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'gdv', '<Cmd>vsplit | lua vim.lsp.buf.definition()<CR>', opts)
  buf_set_keymap('n', 'K', '<Cmd>lua vim.lsp.buf.hover()<CR>', opts)
  buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
  buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
  buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
  buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
  buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
  buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
  buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
  buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.lsp.diagnostic.show_line_diagnostics()<CR>', opts)
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)

end

local rust_attach = function(client, bufnr)
  on_attach(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end


-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "kotlin_language_server", "pyright", "rust_analyzer", "tsserver" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    flags = {
      debounce_text_changes = 150,
    }
  }
end


require('lspconfig').elixirls.setup{
	on_attach = on_attach,
	cmd = { "/Users/aross/projects/elixir-ls/release/language_server.sh" }
}

require('lspconfig').ruby_lsp.setup{
  on_attach = on_attach,
  cmd = { "bundle", "exec", "ruby-lsp" },
  settings = {
    rubyLsp = {
     diagnostics = {
       enable = true,
     },
    }
  }
}

-- Configure rust-analyzer
require'lspconfig'.rust_analyzer.setup({
  on_attach = rust_attach,
})

local fzf = require('fzf-lua')

-- require('fzf-lua').setup({})
require('fzf-lua').setup {
  winopts = {
    preview = {
      default = 'bat',  -- Use 'bat' for syntax-highlighted previews which is much faster than treesitter
    },
  },
}


vim.keymap.set('n', '<leader>ff', fzf.files, {})
vim.keymap.set('n', '<leader>fgt', fzf.git_files, {})
vim.keymap.set('n', '<leader>fg', fzf.live_grep, {})
vim.keymap.set('n', '<leader>fb', fzf.buffers, {})
vim.keymap.set('n', '<leader>fh', fzf.help_tags, {})
vim.keymap.set('n', '<leader>fw', function() fzf.grep({ search = vim.fn.expand('<cword>') }) end, { noremap = true, silent = true })

require("Comment").setup()

require'nvim-treesitter.configs'.setup {
  ensure_installed = "all", -- install parsers for all supported languages
  sync_install = false,
  auto_install = true,
  ignore_install = { },
  highlight = {
    enable = true,
    disable = { },
  },
  indent = {
    enable = true,
  },
}

require'nvim-web-devicons'.setup {
  -- your personnal icons can go here (to override)
  -- you can specify color or cterm_color instead of specifying both of them
  -- DevIcon will be appended to `name`
  override = {
    zsh = {
      icon = "",
      color = "#428850",
      cterm_color = "65",
      name = "Zsh"
    }
  };
  -- globally enable different highlight colors per icon (default to true)
  -- if set to false all icons will have the default icon's color
  color_icons = true;
  -- globally enable default icons (default to false)
  -- will get overriden by `get_icons` option
  default = true;
  -- globally enable "strict" selection of icons - icon will be looked up in
  -- different tables, first by filename, and if not found by extension; this
  -- prevents cases when file doesn't have any extension but still gets some icon
  -- because its name happened to match some extension (default to false)
  strict = true;
  -- same as `override` but specifically for overrides by filename
  -- takes effect when `strict` is true
  override_by_filename = {
    [".gitignore"] = {
      icon = "",
      color = "#f1502f",
      name = "Gitignore"
    }
  };
  -- same as `override` but specifically for overrides by extension
  -- takes effect when `strict` is true
  override_by_extension = {
    ["log"] = {
      icon = "",
      color = "#81e043",
      name = "Log"
    }
  };
  -- same as `override` but specifically for operating system
  -- takes effect when `strict` is true
  override_by_operating_system = {
    ["apple"] = {
      icon = "",
      color = "#A2AAAD",
      cterm_color = "248",
      name = "Apple",
    },
  };
}

if vim.fn.has("termguicolors") == 1 then
  vim.opt.termguicolors = true
end

-- vim test set up



vim.g["test#neovim#term_position"] = "vert botright 30"
vim.g["test#strategy"] = "vimux"

-- Set key mappings for test commands
vim.api.nvim_set_keymap('n', '<leader>t', ':TestNearest<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>T', ':TestFile<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>a', ':TestSuite<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>l', ':TestLast<CR>', { noremap = true, silent = true })
vim.api.nvim_set_keymap('n', '<leader>g', ':TestVisit<CR>', { noremap = true, silent = true })

-- Function to run Bazel test
function _G.RunBazelTest(...)
  local command = 'bazel test'
  local args = table.concat({...}, ' ')
  if args ~= '' then
    command = command .. ' ' .. args
  end
  return command
end

-- Set Kotlin-specific test settings
vim.api.nvim_exec([[
  augroup KotlinTestSettings
    autocmd!
    autocmd FileType kotlin lua vim.g['test#custom_strategies'] = { bazel = _G.RunBazelTest }
    autocmd FileType kotlin let test#strategy = 'bazel'
    autocmd FileType kotlin let g:test#kotlin#gradle#executable = "bazel test"
  augroup END
]], false)

