local function create_on_attach()
  vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
      local bufnr = args.buf

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
      nmap("K", vim.lsp.buf.hover, "Hover Documentation")
      nmap("gD", vim.lsp.buf.declaration, "[G]oto [D]eclaration")
      nmap("<leader>wl", function()
        print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
      end, "[W]orkspace [L]ist Folders")
    end,
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
      automatic_enable = false,
      ensure_installed = {
        "lua_ls",
        "basedpyright",
        "zuban",
        "ruff",
        "ts_ls",
        "biome",
        "terraformls",
        "bashls",
        "gh_actions_ls",
        "zizmor",
        "typos_lsp",
      },
    })

    create_on_attach()

    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    vim.lsp.config("lua_ls", {
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
    })

    vim.lsp.config("basedpyright", {
      on_init = function(client)
        client.server_capabilities.hoverProvider = false
        client.server_capabilities.definitionProvider = false
        client.server_capabilities.declarationProvider = false
        client.server_capabilities.typeDefinitionProvider = false
        client.server_capabilities.implementationProvider = false
        client.server_capabilities.referencesProvider = false
        client.server_capabilities.documentHighlightProvider = false
        client.server_capabilities.documentFormattingProvider = false
        client.server_capabilities.documentRangeFormattingProvider = false
        client.server_capabilities.renameProvider = false
        client.server_capabilities.signatureHelpProvider = nil
        client.server_capabilities.codeActionProvider = false
      end,
      settings = {
        basedpyright = {
          analysis = {
            typeCheckingMode = "standard",
          },
        },
      },
    })

    vim.lsp.config("zuban", {
      name = "zuban",
      -- Prefer diagnostics from basedpyright for now
      on_init = function(client)
        -- client.server_capabilities.diagnosticProvider = nil
        -- client.server_capabilities.referencesProvider = false
        client.server_capabilities.documentSymbolProvider = false
      end,
    })

    vim.lsp.config("terraformls", {
      filetypes = { "terraform" },
      -- terraform-ls outputs all logs to stderr for some reason, making everything have log level ERROR
      -- cmd = { "terraform-ls", "serve", "-log-file", vim.fs.dirname(require("vim.lsp.log").get_filename()) .. "/terraform-ls.log" },
      cmd = { "terraform-ls", "serve", "-log-file", "/dev/null" },
    })

    vim.lsp.config("bashls", {
      filetypes = { "sh", "zsh", "bash" },
    })

    vim.lsp.config("typos_lsp", {
      init_options = {
        config = vim.fn.stdpath("config") .. "/typos.toml",
        diagnosticSeverity = "Hint",
      },
    })

    vim.lsp.enable({
      "lua_ls",
      "zuban",
      "basedpyright",
      "ts_ls",
      "biome",
      "terraformls",
      "bashls",
      "gh_actions_ls",
      "zizmor",
      "typos_lsp",
    })
  end,
}
