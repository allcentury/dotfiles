----------------------------------
      -- Vim configuration
----------------------------------
local vim = _G.vim
vim.cmd('filetype plugin indent on')
vim.o.autoindent = true
vim.g.mapleader = ','
vim.o.expandtab = true  -- expand tab input with spaces characters
vim.o.smartindent = true -- syntax aware indentations for newline inserts
vim.o.tabstop = 2 -- num of space characters per tab
vim.o.shiftwidth = 2 -- spaces per indentation level
vim.wo.relativenumber = true
-- disable netrw to use nvim-tree
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.clipboard = "unnamedplus"

----------------------------------
      -- Autocommands
----------------------------------
local group = vim.api.nvim_create_augroup('TrimWhitespaceGroup', { clear = true })
-- Define the autocommand to trim trailing whitespace on save
vim.api.nvim_create_autocmd('BufWritePre', {
  group = group,
  pattern = '*',
  command = [[%s/\s\+$//e]],
})

-- Ensure Ruby filetype is recognized
vim.api.nvim_exec([[
  au BufRead,BufNewFile *.rb set filetype=ruby
]], false)

----------------------------------
      -- Diagnostics Configuration
----------------------------------
-- Configure diagnostics to be more obvious
vim.diagnostic.config({
  virtual_text = {
    prefix = '●',
    source = "always",
    spacing = 4,
  },
  signs = true,
  underline = { severity = { min = vim.diagnostic.severity.ERROR } }, -- Only underline errors
  update_in_insert = false,
  severity_sort = true,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
    focusable = false,
    style = 'minimal',
  },
})

-- Auto-show diagnostics in a floating window on cursor hold
vim.api.nvim_create_autocmd("CursorHold", {
  pattern = "*",
  callback = function()
    -- Only show if there are diagnostics on the current line
    local opts = {
      focusable = false,
      close_events = { "BufLeave", "CursorMoved", "InsertEnter", "FocusLost" },
      border = 'rounded',
      source = 'always',
      prefix = ' ',
      scope = 'cursor',
    }
    vim.diagnostic.open_float(nil, opts)
  end
})

-- Optionally adjust how quickly the float appears (default is 4000ms = 4s)
vim.opt.updatetime = 1000  -- Show diagnostic float after 1 second of holding cursor

-- Define diagnostic signs for the gutter (modern approach)
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = "" })
end

-- Enhanced hover and signature help with borders
vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(
  vim.lsp.handlers.hover, {
    border = "rounded"
  }
)

vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
  vim.lsp.handlers.signature_help, {
    border = "rounded"
  }
)

----------------------------------
      -- Plugins
----------------------------------
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
  -- Mason for LSP/tool management
  {
    "williamboman/mason.nvim",
    config = function()
      require("mason").setup()
    end,
  },
  {
    "williamboman/mason-lspconfig.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    dependencies = { "williamboman/mason.nvim" },
  },
  -- Completion plugins
  {
    "hrsh7th/nvim-cmp",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-cmdline",
      "L3MON4D3/LuaSnip",
      "saadparwaiz1/cmp_luasnip",
      "rafamadriz/friendly-snippets",
      "onsails/lspkind.nvim",
    },
  },
  -- Formatting and linting
  {
    "nvimtools/none-ls.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
  },
  {
    "nvimtools/none-ls-extras.nvim",
  },
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
  -- "github/copilot.vim",
  "nvim-treesitter/nvim-treesitter",
  'vim-ruby/vim-ruby',
  { "folke/neodev.nvim", opts = {} },
  "preservim/vimux",
  "spiegela/vimix",
  "vim-test/vim-test",
  "tpope/vim-surround",
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
  'andymass/vim-matchup',
  {
    "Rawnly/gist.nvim",
    cmd = { "GistCreate", "GistCreateFromFile", "GistsList" },
    config = true
  },
  -- `GistsList` opens the selected gist in a terminal buffer,
  -- nvim-unception uses neovim remote rpc functionality to open the gist in an actual buffer
  -- and prevents neovim buffer inception
  {
    "samjwill/nvim-unception",
    lazy = false,
    init = function() vim.g.unception_block_while_host_edits = true end
  },
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && yarn install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
    end,
    ft = { "markdown" },
  },
  {
    'nvim-telescope/telescope.nvim', tag = '0.1.8',
    dependencies = { 'nvim-lua/plenary.nvim' }
  },
  "nvim-tree/nvim-tree.lua",
  {
    "allcentury/telescope_csearch.nvim",
    requires = { "nvim-telescope/telescope.nvim" },
    config = function()
      require('telescope_csearch').setup({
        index_path = '~/.csearchindex'
      })
    end,
    cond = function()
      return vim.fn.executable('csearch')
    end
  },
})


require('nvim-tree').setup()
require('crates').setup()

require("neodev").setup({})

----------------------------------
      -- Mason Setup
----------------------------------
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = {
    "lua_ls",
    "ts_ls",  -- TypeScript/JavaScript
    "pyright",
    "rust_analyzer",
  },
  automatic_installation = true,
})

require("mason-tool-installer").setup({
  ensure_installed = {
    "prettier",
    "eslint_d",
    "stylua",
  },
})

----------------------------------
      -- nvim-cmp Setup
----------------------------------
local cmp = require('cmp')
local lspkind = require('lspkind')
local luasnip = require('luasnip')

-- Load friendly snippets
require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  completion = {
    autocomplete = {
      require('cmp.types').cmp.TriggerEvent.TextChanged
    },
  },
  experimental = {
    ghost_text = true,  -- Show preview of completion
  },
  mapping = cmp.mapping.preset.insert({
    ['<C-b>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),
    ['<C-Space>'] = cmp.mapping.complete(),
    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({ select = true }),
    ['<Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_next_item()
      elseif luasnip.expand_or_jumpable() then
        luasnip.expand_or_jump()
      else
        fallback()
      end
    end, { 'i', 's' }),
    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item()
      elseif luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, { 'i', 's' }),
  }),
  sources = cmp.config.sources({
    { name = 'nvim_lsp' },
    { name = 'luasnip' },
  }, {
    { name = 'buffer' },
    { name = 'path' },
  }),
  formatting = {
    format = lspkind.cmp_format({
      mode = 'symbol_text',
      maxwidth = 50,
      ellipsis_char = '...',
      menu = {
        buffer = "[BUF]",
        nvim_lsp = "[LSP]",
        luasnip = "[SNIP]",
        path = "[PATH]",
      },
    }),
  },
})

-- Use buffer source for `/` and `?`
cmp.setup.cmdline({ '/', '?' }, {
  mapping = cmp.mapping.preset.cmdline(),
  sources = {
    { name = 'buffer' }
  }
})

-- Use cmdline & path source for ':'
cmp.setup.cmdline(':', {
  mapping = cmp.mapping.preset.cmdline(),
  sources = cmp.config.sources({
    { name = 'path' }
  }, {
    { name = 'cmdline' }
  })
})

----------------------------------
      -- none-ls Setup
----------------------------------
local null_ls = require("null-ls")

null_ls.setup({
  sources = {
    null_ls.builtins.formatting.prettier,
    null_ls.builtins.formatting.stylua,
    -- Disable eslint_d for now - uncomment when you have an ESLint config
    -- require("none-ls.diagnostics.eslint_d"),
  },
})
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

function CopyDiagnosticsToClipboard()
  local diagnostics = vim.diagnostic.get(0)
  local message = ""
  for _, diagnostic in ipairs(diagnostics) do
    message = message .. diagnostic.message .. "\n"
  end
  vim.fn.setreg("+", message)  -- Copy to the system clipboard
  print("Diagnostics copied to clipboard")
end

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
  local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

  --Enable completion triggered by <c-x><c-o>
  buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

  -- Enable inlay hints if supported (TypeScript)
  if client.server_capabilities.inlayHintProvider then
    vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
  end

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
  buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })<CR>', opts)
  buf_set_keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float(nil, { focusable = false, border = "rounded" })<CR>', opts)  -- Alternate keybind
  buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
  buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
  buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
  buf_set_keymap("n", "<space>f", "<cmd>lua vim.lsp.buf.formatting()<CR>", opts)
  buf_set_keymap("n", "<space>ce", '<cmd>lua CopyDiagnosticsToClipboard()<CR>', opts)

end

local rust_attach = function(client, bufnr)
  on_attach(client, bufnr)
  vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
end


-- Set up nvim-cmp capabilities
local capabilities = require('cmp_nvim_lsp').default_capabilities()

-- Use a loop to conveniently call 'setup' on multiple servers and
-- map buffer local keybindings when the language server attaches
local servers = { "kotlin_language_server", "pyright", "rust_analyzer" }
for _, lsp in ipairs(servers) do
  nvim_lsp[lsp].setup {
    on_attach = on_attach,
    capabilities = capabilities,
    flags = {
      debounce_text_changes = 150,
    }
  }
end

-- Setup TypeScript LSP (ts_ls)
local function organize_imports()
  local params = {
    command = "_typescript.organizeImports",
    arguments = { vim.api.nvim_buf_get_name(0) },
    title = "",
  }
  vim.lsp.buf.execute_command(params)
end

nvim_lsp.ts_ls.setup({
  on_attach = on_attach,
  capabilities = capabilities,
  commands = {
    OrganizeImports = {
      organize_imports,
      description = "Organize Imports"
    }
  },
})


require('lspconfig').elixirls.setup{
	on_attach = on_attach,
	capabilities = capabilities,
	cmd = { "/Users/aross/projects/elixir-ls/release/language_server.sh" }
}

require('lspconfig').ruby_lsp.setup{
  on_attach = on_attach,
  capabilities = capabilities,
  cmd = { "bundle", "exec", "ruby-lsp" },
  settings = {
    rubyLsp = {
     diagnostics = {
       enable = true,
     },
    }
  }
}

--[[ require('lspconfig').biome.setup{}
]]
-- Configure rust-analyzer
require'lspconfig'.rust_analyzer.setup({
  on_attach = rust_attach,
  capabilities = capabilities,
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

-- Right now i'm using telescope for file search so i'm disabling these mappings for fzf

-- vim.keymap.set('n', '<leader>ff', fzf.files, {})
-- vim.keymap.set('n', '<leader>fgt', fzf.git_files, {})
-- vim.keymap.set('n', '<leader>fg', fzf.live_grep, {})
-- vim.keymap.set('n', '<leader>fb', fzf.buffers, {})
-- vim.keymap.set('n', '<leader>fh', fzf.help_tags, {})
-- vim.keymap.set('n', '<leader>fw', function() fzf.grep({ search = vim.fn.expand('<cword>') }) end, { noremap = true, silent = true })

require("Comment").setup()

require'nvim-treesitter.configs'.setup {
  ensure_installed = {
    "vimdoc",
    "vim",
    "javascript",
    "lua",
    "typescript",
    "tsx",
    "json",
    "html",
    "css",
    "ruby",
    "yaml",
    "elixir",
    "rust",
    "markdown",
  },
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
  matchup = {
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

-- Configure vim-test to work with Kotlin Bazel tests
vim.g["test#kotlin#runner"] = "bazel" -- Use our custom Bazel runner
vim.g["test#kotlin#patterns"] = {
  test = {".*Test.kt", ".*Tests.kt", ".*IntegrationTest.kt"},
  namespace = {".*"}
}

-- Custom test transformers for Kotlin with Bazel
vim.g["test#custom_transformers"] = {}
-- Set Kotlin-specific test settings
vim.api.nvim_exec([[
  augroup KotlinTestSettings
    autocmd!
    autocmd FileType kotlin let test#kotlin#bazel#executable = "bash -c"
    autocmd FileType kotlin let test#kotlin#bazel#file_pattern = '\vTest\\.kt$|Tests\\.kt$|IntegrationTest\\.kt$'
    autocmd FileType kotlin let test#transformation = 'kotlin_bazel'
    autocmd FileType kotlin let test#strategy = 'vimux'
  augroup END
]], false)


-- copilot setup
-- vim.keymap.set('i', '<C-L>', '<Plug>(copilot-accept-word)')

require("gist").setup({
  private = false, -- All gists will be private, you won't be prompted again
  clipboard = "+", -- The registry to use for copying the Gist URL
  list = {
    -- If there are multiple files in a gist you can scroll them,
    -- with vim-like bindings n/p next previous
    mappings = {
      next_file = "<C-n>",
      prev_file = "<C-p>"
    }
  }
})

-- Configure Telescope to respect .gitignore
require('telescope').setup({
  defaults = {
    file_ignore_patterns = {
      "node_modules",
      ".git/",
    },
    vimgrep_arguments = {
      "rg",
      "--color=never",
      "--no-heading",
      "--with-filename",
      "--line-number",
      "--column",
      "--smart-case",
      "--hidden",  -- Search hidden files
      "--glob=!.git/",  -- But exclude .git
      "--glob=!node_modules/",  -- Exclude node_modules
    },
  },
  pickers = {
    find_files = {
      hidden = true,  -- Show hidden files
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*", "--glob", "!node_modules/*" },
    },
  },
})

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>fg', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })

vim.keymap.set('n', '<leader>cs', function()
  require('telescope_csearch').csearch()
end, { desc = 'CSearch grep' })

vim.keymap.set('n', '<leader>csw', function()
  require('telescope_csearch').csearch({
    default_text = vim.fn.expand('<cword>')
  })
end, { desc = 'CSearch word under cursor' })

vim.keymap.set('n', '<leader>fw', function() fzf.grep({ search = vim.fn.expand('<cword>') }) end, { noremap = true, silent = true })

-- execute a file if we know how to
-- Define a function to create Vimux run command mappings based on file type
local function set_filetype_run_command(filetype, command)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = filetype,
    callback = function()
      -- "preservim/vimux",
      vim.api.nvim_buf_set_keymap(0, "n", "<leader>e", ":w<CR>:VimuxRunCommand('" .. command .. " ' .. expand('%:p'))<CR>", { noremap = true, silent = true })
    end
  })
end

-- Set run command for Python files
set_filetype_run_command("python", "python3")

-- Set run command for Ruby files
set_filetype_run_command("ruby", "ruby")

-- Convert selected lines to SQL IN clause
-- useful if you're copying from a csv (rows) into an empty vim buffer
function ConvertToSqlIn()
  -- Get the visual selection range
  local start_line = vim.fn.line("'<")
  local end_line = vim.fn.line("'>")

  -- Get the lines
  local lines = vim.api.nvim_buf_get_lines(0, start_line - 1, end_line, false)

  -- Wrap each line in quotes and join with commas
  local quoted = {}
  for _, line in ipairs(lines) do
    local trimmed = line:match("^%s*(.-)%s*$")  -- trim whitespace
    if trimmed ~= "" then
      table.insert(quoted, "'" .. trimmed .. "'")
    end
  end

  -- Build the SQL query
  local sql = "("
              .. table.concat(quoted, ", ")
              .. ")"

  -- Replace the selection with the SQL query
  vim.api.nvim_buf_set_lines(0, start_line - 1, end_line, false, {sql})
end

-- Create a keymap (use in visual mode: select lines, then press <leader>sq)
vim.keymap.set('v', '<leader>sq', ':<C-u>lua ConvertToSqlIn()<CR>',
  { noremap = true, silent = true, desc = 'Convert to SQL IN query' })
