-- lsp config
return {
  "neovim/nvim-lspconfig",
  dependencies = {
    {
      "folke/lazydev.nvim",
      ft = "lua",
      opts = {
        library = {
          { path = "${3rd}/luv/library", words = { "vim%.uv" } },
        },
      },
    },
    "williamboman/mason.nvim",
    "williamboman/mason-lspconfig.nvim",
  },
  config = function()
    vim.lsp.log.set_level("error")

    require("mason").setup({
      ui = {
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    local capabilities = require("cmp_nvim_lsp").default_capabilities()

    require("mason-lspconfig").setup({
      ensure_installed = {
        "lua_ls",
        "pyright",
        "ruff",
        "gopls",
        "rust_analyzer",
        "clangd",
        "bashls",
        "ts_ls",
      },
      handlers = {
        -- default handler
        function(server_name)
          vim.lsp.config(server_name, {
            capabilities = capabilities,
          })
          vim.lsp.enable(server_name)
        end,

        ["pyright"] = function()
          vim.lsp.config("pyright", {
            capabilities = capabilities,
            settings = {
              pyright = {
                disableOrganizeImports = true,
              },
              python = {
                analysis = {
                  ignore = { "*" },
                },
              },
            },
          })
          vim.lsp.enable("pyright")
        end,

        ["ruff"] = function()
          vim.lsp.config("ruff", {
            capabilities = capabilities,
            init_options = {
              settings = {
                lineLength = 88,
                fixAll = true,
                organizeImports = true,
              },
            },
          })
          vim.lsp.enable("ruff")
        end,

        ["gopls"] = function()
          vim.lsp.config("gopls", {
            capabilities = capabilities,
            settings = {
              gopls = {
                completeUnimported = true,
                usePlaceholders = true,
              },
            },
          })
          vim.lsp.enable("gopls")
        end,

        ["ts_ls"] = function()
          vim.lsp.config("ts_ls", {
            capabilities = capabilities,
            settings = {
              completions = {
                completeFunctionCalls = true,
              },
            },
          })
          vim.lsp.enable("ts_ls")
        end,

        ["clangd"] = function()
          vim.lsp.config("clangd", {
            capabilities = capabilities,
            cmd = {
              "clangd",
              "--background-index",
              "--clang-tidy",
              "--completion-style=detailed",
              "--header-insertion=iwyu",
              "--header-insertion-decorators",
              "--pch-storage=memory",
            },
            settings = {
              clangd = {
                fallbackFlags = { "-std=c++17" },
              },
            },
          })
          vim.lsp.enable("clangd")
        end,
      },
    })

    -- format on save, scoped to whichever attached client supports it
    -- (avoids ambiguity when multiple clients attach to the same buffer,
    -- e.g. pyright + ruff, or lua_ls + null-ls's stylua)
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method("textDocument/formatting") then
          vim.api.nvim_create_autocmd("BufWritePre", {
            buffer = args.buf,
            callback = function()
              vim.lsp.buf.format({ id = client.id, async = false })
            end,
          })
        end
      end,
    })

    vim.diagnostic.config({
      virtual_text = {
        severity = { min = vim.diagnostic.severity.WARN },
        source = "if_many",
      },
      signs = true,
      underline = true,
      update_in_insert = false,
      float = {
        focusable = false,
        style = "minimal",
        source = "always",
        header = "",
        prefix = "",
      },
      severity_sort = true,
    })

    -- LSP keymaps, scoped to buffer on attach
    vim.api.nvim_create_autocmd("LspAttach", {
      callback = function(args)
        local opts = { buffer = args.buf }

        -- navigation
        vim.keymap.set(
          "n",
          "K",
          vim.lsp.buf.hover,
          vim.tbl_extend("force", opts, { desc = "Hover documentation" })
        )
        vim.keymap.set(
          "n",
          "gd",
          vim.lsp.buf.definition,
          vim.tbl_extend("force", opts, { desc = "Go to definition" })
        )
        vim.keymap.set(
          "n",
          "gr",
          vim.lsp.buf.references,
          vim.tbl_extend("force", opts, { desc = "Go to references" })
        )
        vim.keymap.set(
          "n",
          "gi",
          vim.lsp.buf.implementation,
          vim.tbl_extend("force", opts, { desc = "Go to implementation" })
        )
        vim.keymap.set(
          "n",
          "gt",
          vim.lsp.buf.type_definition,
          vim.tbl_extend("force", opts, { desc = "Go to type definition" })
        )

        -- actions
        vim.keymap.set(
          "n",
          "<leader>cf",
          vim.lsp.buf.format,
          vim.tbl_extend("force", opts, { desc = "Format buffer" })
        )
        vim.keymap.set(
          "n",
          "<leader>ca",
          vim.lsp.buf.code_action,
          vim.tbl_extend("force", opts, { desc = "Code action" })
        )
        vim.keymap.set(
          "n",
          "<leader>rn",
          vim.lsp.buf.rename,
          vim.tbl_extend("force", opts, { desc = "Rename symbol" })
        )
      end,
    })
  end,
}
