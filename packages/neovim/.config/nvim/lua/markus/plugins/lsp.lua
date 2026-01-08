local setup_snippets = function()
  -- https://github.com/L3MON4D3/LuaSnip/blob/master/DOC.md#lua
  local ls = require("luasnip")
  local s = ls.snippet
  local t = ls.text_node
  local i = ls.insert_node

  vim.keymap.set({ "i", "s" }, "<C-l>", function() ls.jump(1) end, { silent = true })
  vim.keymap.set({ "i", "s" }, "<C-h>", function() ls.jump(-1) end, { silent = true })

  ls.add_snippets("python", {
    s("def", {
      t("def "), i(1, "foo"), t("("), i(2), t(") -> "), i(3, "None"), t({ ":", "" }),
      t("    "), i(4, "pass")
    })
  })
end

local on_attach = function(client, bufnr)
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

  -- Fixes (un)comment command for terraform files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform",
    callback = function()
      vim.bo.commentstring = "# %s"
    end
  })

  -- Enable/disable capabilites
  -- TODO somethings broken with this :(
  if client.name == "ruff" then
    --   client.server_capabilities.diagnosticProvider = false
    client.server_capabilities.hoverProvider = false
    -- elseif client.name == "basedpyright" then
    --   client.server_capabilities.documentFormattingProvider = false
    --   client.server_capabilities.documentRangeFormattingProvider = false
  end

  -- Autoformat on save
  vim.api.nvim_create_autocmd("BufWritePre", {
    buffer = bufnr,
    callback = function()
      if client.supports_method("textDocument/formatting") then
        vim.lsp.buf.format({ async = false, id = client.id })
      end
    end
  })
end

-- Available capabilites
-- client.server_capabilities.callHierarchyProvider = false
-- client.server_capabilities.codeActionProvider = false
-- client.server_capabilities.completionProvider = false
-- client.server_capabilities.declarationProvider = false
-- client.server_capabilities.definitionProvider = false
-- client.server_capabilities.diagnosticProvider = false
-- client.server_capabilities.documentFormattingProvider = false
-- client.server_capabilities.documentHighlightProvider = false
-- client.server_capabilities.documentRangeFormattingProvider = false
-- client.server_capabilities.documentSymbolProvider = false
-- client.server_capabilities.foldingRangeProvider = false
-- client.server_capabilities.hoverProvider = false
-- client.server_capabilities.implementationProvider = false
-- client.server_capabilities.referencesProvider = false
-- client.server_capabilities.renameProvider = false
-- client.server_capabilities.semanticTokensProvider = false
-- client.server_capabilities.signatureHelpProvider = false
-- client.server_capabilities.typeDefinitionProvider = false
-- client.server_capabilities.workspaceSymbolProvider = false

local function filter(func, list)
  local result = {}
  for _, value in ipairs(list) do
    if func(value) then
      result.insert(value)
    end
  end
  return result
end

-- Directory prefix of all package directories
local package_prefix = vim.fn.expand((vim.env.XDG_DATA_HOME or '~/.local/share') .. '/nvim/site/')

local function is_package_path(path)
  if package_prefix ~= string.sub(path, 1, #package_prefix) then
    return false
  end
  return vim.fn.isdirectory(path .. '/lua') ~= 0
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
  event = "VeryLazy",

  config = function()
    require("conform").setup({
      formatters_by_ft = {
      }
    })
    local cmp = require('cmp')
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities = vim.tbl_deep_extend(
      "force",
      vim.lsp.protocol.make_client_capabilities(),
      cmp_lsp.default_capabilities(),
      {
        offsetEncoding = { "utf-16" },
        general = {
          positionEncodings = { "utf-16" },
        },
      }
    )

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "basedpyright",
        "ruff",
        "ts_ls",
        "terraformls",
        "bashls",
      },
    })

    vim.lsp.config("*",
      {
        capabilities = capabilities,
        on_attach = on_attach,
      }
    )

    vim.lsp.config.lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = {
            globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
          },
          workspace = {
            -- See https://www.reddit.com/r/neovim/comments/x3bd4i/how_can_i_get_lsp_to_recognize_builtin_neovim_api/
            library = filter(is_package_path, vim.api.nvim_get_runtime_file("", true))
          },
          telemetry = { enable = false },
        }
      }
    }

    vim.lsp.config.basedpyright = {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
            diagnosticMode = "openFilesOnly",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            extraPaths = {
            },
          }
        }
      }
    }

    vim.lsp.config.terraformls = {
      filetypes = { "terraform" },
      -- cmd = { "terraform-ls", "serve", "-log-file", vim.fs.dirname(require("vim.lsp.log").get_filename()) .. "/terraform-ls.log" },
      cmd = { "terraform-ls", "serve", "-log-file", "/dev/null" },
    }

    vim.lsp.config.ruff = {
      init_options = {
        settings = {
          logLevel = "warn",
        },
      },
    }

    local cmp_select = { behavior = cmp.SelectBehavior.Select }

    setup_snippets()

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
        ["<S-Esc>"] = cmp.mapping.abort(),
      }),
      sources = cmp.config.sources({
          { name = 'nvim_lsp', priority = 8 },
          { name = 'luasnip',  priority = 7 }, -- For luasnip users.
        },
        {
          { name = 'buffer', priority = 6 },
        }),
      comparators = {
        cmp.config.compare.locality,
        cmp.config.compare.recently_used,
        cmp.config.compare.score,
        cmp.config.compare.offset,
        cmp.config.compare.order,
      },
    })

    vim.diagnostic.config({
      -- update_in_insert = true,
      virtual_text = true,
      severity_sort = true,
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "",
          [vim.diagnostic.severity.WARN] = "",
          [vim.diagnostic.severity.HINT] = "󰌵",
        },
        linehl = {
        },
        numhl = {
          [vim.diagnostic.severity.ERROR] = "ErrorMsg",
          [vim.diagnostic.severity.WARN] = "WarningMsg",
        },
      },
      float = {
        focusable = false,
        style = "minimal",
        border = "rounded",
        source = true,
        header = "",
        prefix = "",
      },
    })
  end
}
