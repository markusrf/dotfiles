local on_attach = function(_, bufnr)
  -- NOTE: Remember that lua is a real programming language, and as such it is possible
  -- to define small helper and utility functions so you don't have to repeat yourself
  -- many times.
  --
  -- In this case, we create a function that lets us more easily define mappings specific
  -- for LSP related items. It sets the mode, buffer and description for us each time.
  local nmap = function(keys, func, desc)
    if desc then
      desc = 'LSP: ' .. desc
    end

    vim.keymap.set('n', keys, func, { buffer = bufnr, desc = desc })
  end

  nmap('<leader>rn', vim.lsp.buf.rename, '[R]e[n]ame')
  nmap('<leader>ca', vim.lsp.buf.code_action, '[C]ode [A]ction')
  nmap('gd', vim.lsp.buf.definition, '[G]oto [D]efinition')
  nmap('<leader>gr', require('telescope.builtin').lsp_references, '[G]oto [R]eferences')
  nmap('gI', vim.lsp.buf.implementation, '[G]oto [I]mplementation')
  nmap('<leader>D', vim.lsp.buf.type_definition, 'Type [D]efinition')
  nmap('<leader>ds', require('telescope.builtin').lsp_document_symbols, '[D]ocument [S]ymbols')
  nmap('<leader>ws', require('telescope.builtin').lsp_dynamic_workspace_symbols, '[W]orkspace [S]ymbols')
  nmap('<leader>dn', function ()
    vim.diagnostic.jump({ count = 1, float = true })
  end, 'Jump to next diagnostic')
  nmap('<leader>dp', function ()
    vim.diagnostic.jump({ count = -1, float = true })
  end, 'Jump to previous diagnostic')

  -- See `:help K` for why this keymap
  nmap('K', vim.lsp.buf.hover, 'Hover Documentation')
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap('gD', vim.lsp.buf.declaration, '[G]oto [D]eclaration')
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap('<leader>wl', function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, '[W]orkspace [L]ist Folders')

  -- Create a command `:Format` local to the LSP buffer
  vim.api.nvim_buf_create_user_command(bufnr, 'Format', function(_)
    if vim.lsp.buf.format then
      vim.lsp.buf.format()
    elseif vim.lsp.buf.formatting then
      vim.lsp.buf.formatting()
    end
  end, { desc = 'Format current buffer with LSP' })
  nmap('<leader>gf', '<CMD>Format<CR>', '[F]ormat buffer with LSP')

  vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform",
    callback = function()
      vim.bo.commentstring = "# %s"
    end
  })
end

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "stevearc/conform.nvim",
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "hrsh7th/cmp-buffer",
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-cmdline",
    "hrsh7th/nvim-cmp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip",
    "j-hui/fidget.nvim",
  },

  config = function()
    require("conform").setup({
      formatters_by_ft = {
      }
    })
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      {},
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities())

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "basedpyright",
        "ruff",
        "ts_ls",
        "terraformls",
        "bashls",
      },
      handlers = {
        function(server_name) -- default handler (optional)
          require("lspconfig")[server_name].setup {
            capabilities = capabilities,
            on_attach = on_attach,
          }
        end,

        ["lua_ls"] = function()
          local lspconfig = require("lspconfig")
          lspconfig.lua_ls.setup {
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              Lua = {
                runtime = { version = "LuaJIT" },
                diagnostics = {
                  globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                }
              }
            }
          }
        end,

        -- TODO - configure pyright, formatter, mypy etc
        ["pyright"] = function()
          local lspconfig = require("lspconfig")
          -- lspconfig.pyright.setup {
          --   capabilities = capabilities,
          --   on_attach = on_attach,
          --   -- cmd = { 'pyright-langserver', '--stdio' },
          --   -- filetypes = { 'python' },
          --   -- root_dir = function(fname)
          --   --   return util.root_pattern(unpack(root_files))(fname)
          --   -- end,
          --   single_file_support = true,
          --   settings = {
          --     python = {
          --       analysis = {
          --         -- autoSearchPaths = true,
          --         -- useLibraryCodeForTypes = true,
          --         -- diagnosticMode = 'openFilesOnly',
          --         -- typeCheckingMode = "off", -- off, basic, standard, strict
          --       },
          --     },
          --   },
          -- }
          lspconfig.ruff.setup({
            capabilities = capabilities,
            -- init_options = {
            --   settings = {
            --     -- Docs: https://docs.astral.sh/ruff/editors/settings/#ignore
            --     lint = {
            --     }
            --   }
            -- }
          })
        end,

        ["basedpyright"] = function ()
          local lspconfig = require("lspconfig")
          lspconfig.basedpyright.setup({
            capabilities = capabilities,
            on_attach = on_attach,
            settings = {
              basedpyright = {
                analysis = {
                  typeCheckingMode = "off",
                  extraPaths = {
                  },
                }
              }
            }
          })
        end,
      }
    })

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    cmp.setup({
      snippet = {
        expand = function(args)
          require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
        end,
      },
      mapping = cmp.mapping.preset.insert({
        ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
        ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<S-Esc>"] = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
          -- { name = "copilot", group_index = 2 },
          { name = 'nvim_lsp' },
          { name = 'luasnip' }, -- For luasnip users.
        },
        {
          { name = 'buffer' },
        })
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      virtual_text = true,
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = "always",
        header = "",
        prefix = "",
      },
    })
  end
}
