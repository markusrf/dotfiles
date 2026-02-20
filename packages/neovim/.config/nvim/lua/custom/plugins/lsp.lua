local on_attach = function(client, bufnr)
  local nmap = function(keys, func, desc)
    if desc then
      desc = "LSP: " .. desc
    end

    vim.keymap.set("n", keys, func, { buffer = bufnr, desc = desc })
  end

  nmap("<leader>rn", vim.lsp.buf.rename, "[R]e[n]ame")
  nmap("<leader>ca", vim.lsp.buf.code_action, "[C]ode [A]ction")
  nmap("gd", vim.lsp.buf.definition, "[G]oto [D]efinition")
  nmap("<leader>gr", require("telescope.builtin").lsp_references, "[G]oto [R]eferences")
  nmap("gI", vim.lsp.buf.implementation, "[G]oto [I]mplementation")
  nmap("<leader>D", vim.lsp.buf.type_definition, "Type [D]efinition")
  nmap("<leader>ds", require("telescope.builtin").lsp_document_symbols, "[D]ocument [S]ymbols")
  nmap("<leader>ws", require("telescope.builtin").lsp_dynamic_workspace_symbols, "[W]orkspace [S]ymbols")

  -- See `:help K` for why this keymap
  nmap("K", vim.lsp.buf.hover, "Hover Documentation")
  -- nmap('<C-k>', vim.lsp.buf.signature_help, 'Signature Documentation')

  -- Lesser used LSP functionality
  nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
  -- nmap('<leader>wa', vim.lsp.buf.add_workspace_folder, '[W]orkspace [A]dd Folder')
  -- nmap('<leader>wr', vim.lsp.buf.remove_workspace_folder, '[W]orkspace [R]emove Folder')
  nmap("<leader>wl", function()
    print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
  end, "[W]orkspace [L]ist Folders")

  -- Fixes (un)comment command for terraform files
  vim.api.nvim_create_autocmd("FileType", {
    pattern = "terraform",
    callback = function()
      vim.bo.commentstring = "# %s"
    end,
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

return {
  "neovim/nvim-lspconfig",
  dependencies = {
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
    "hrsh7th/cmp-nvim-lsp",
    "j-hui/fidget.nvim",
  },
  event = "VeryLazy",

  config = function()
    local cmp_lsp = require("cmp_nvim_lsp")
    local capabilities =
      vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities(), {
        offsetEncoding = { "utf-16" },
        general = {
          positionEncodings = { "utf-16" },
        },
      })

    require("fidget").setup({})
    require("mason").setup()
    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "stylua",
        "basedpyright",
        "ruff",
        "ts_ls",
        "biome",
        "terraformls",
        "bashls",
      },
    })

    vim.lsp.config("*", {
      capabilities = capabilities,
      on_attach = on_attach,
    })

    vim.lsp.config.lua_ls = {
      settings = {
        Lua = {
          runtime = { version = "LuaJIT" },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            library = {
              vim.env.VIMRUNTIME .. "/lua",
            },
            checkThirdParty = false,
          },
          telemetry = { enable = false },
        },
      },
    }

    vim.lsp.config.basedpyright = {
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
            diagnosticMode = "openFilesOnly",
            autoSearchPaths = true,
            useLibraryCodeForTypes = true,
            extraPaths = {},
          },
        },
      },
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

    vim.lsp.config.ts_ls = {
      capabilities = capabilities,
      on_attach = on_attach,
    }
  end,
}
