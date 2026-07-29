return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        -- TypeScript / JavaScript (npm: typescript-language-server)
        ts_ls = { mason = false },
        -- Python (npm: pyright)
        pyright = { mason = false },
        -- Rust (rustup: rust-analyzer)
        rust_analyzer = { mason = false },
        -- C / C++ (scoop: clangd)
        clangd = { mason = false },
        -- Lua (scoop: lua-language-server)
        lua_ls = { mason = false },
      },
    },
  },
  -- Kotlin: JetBrains kotlin_lsp (intellij-server は PATH 外のため cmd を上書き)
  {
    "neovim/nvim-lspconfig",
    opts = function(_, opts)
      opts.servers = opts.servers or {}
      opts.servers.kotlin_lsp = {
        mason = false,
        cmd = {
          vim.fn.expand("~/.local/kotlin-lsp/bin/intellij-server.exe"),
          "--stdio",
        },
      }
    end,
  },
  -- Kotlin: treesitter パーサー
  {
    "nvim-treesitter/nvim-treesitter",
    opts = { ensure_installed = { "kotlin" } },
  },
}
