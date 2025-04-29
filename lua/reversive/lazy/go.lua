-- lua/reversive/lazy/go.lua
return {
    -- Ensure Go tools are installed by Mason
    {
      "williamboman/mason.nvim",
      opts = function(_, opts)
        -- Ensure the ensure_installed table exists
        opts.ensure_installed = opts.ensure_installed or {}
        -- Add Go tools to the list
        vim.list_extend(opts.ensure_installed, {
          "gopls",
          "goimports",
          "golangci-lint",
        })
      end,
    },
  
    -- Configure Go LSP (gopls) using the existing lsp.lua setup
    -- We just need to ensure gopls is installed (handled by mason above).
    -- Your lsp.lua's default handler should pick up gopls automatically.
    -- If you need SPECIFIC gopls settings later, you would add a
    -- ["gopls"] = function() ... end handler inside the `handlers` table
    -- in your lua/reversive/lazy/lsp.lua file. For now, we assume defaults are okay.
  
    -- Configure Formatting with conform.nvim
    {
      "stevearc/conform.nvim",
      -- Optional: Load this plugin only for Go files if you prefer
      -- event = { "BufReadPre *.go", "BufNewFile *.go" },
      opts = {
        formatters_by_ft = {
          -- Use goimports for formatting Go files
          go = { "goimports" },
          -- Add other formatters for other languages here if needed
          -- lua = { "stylua" },
          -- python = { "isort", "black" },
        },
        -- If you want format on save (might already be configured globally)
        format_on_save = {
          timeout_ms = 500,
          lsp_fallback = true, -- fallback to LSP formatting if conform fails
        },
      },
    },
  }