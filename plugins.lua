local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "elixir-ls",
        "gopls",
        "gofumpt",
        "golines",
        "goimports-reviser",
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    config = function()
      require "plugins.configs.lspconfig"
      require "custom.configs.lspconfig"
    end,
  },

  --
  -- My plugins
  --

  -- handles escape with jj
  {
    "max397574/better-escape.nvim",
    event = "InsertEnter",
    config = function()
      require("better_escape").setup()
    end,
  },
  -- add/delete/replace surround
  {
    "machakann/vim-sandwich",
    lazy = false,
    keys = {"sa", "sd", "sr"},
    event = "BufRead",
  },
  -- open code on the web
  {
    "linrongbin16/gitlinker.nvim",
    event = "BufRead",
    config = function()
      require("gitlinker").setup()
    end,
  },
  -- strip trailing whitespace
  {
    "echasnovski/mini.trailspace",
    version = false,
    event = "BufRead",
    config = function ()
      require("mini.trailspace").setup()

      vim.api.nvim_create_autocmd("BufWritePre", {
        pattern = "*",
        command = "lua MiniTrailspace.trim()"
      })
    end
  },
  -- git
  {
    "tpope/vim-fugitive",
    event = "BufRead",
  },
  -- end block support
  {
    "RRethy/nvim-treesitter-endwise",
    event = "InsertEnter",
    config = function()
      require("nvim-treesitter.configs").setup({
        endwise = {
          enable = true,
        },
      })
    end,
  },
  -- copilot
  {
    "zbirenbaum/copilot.lua",
    cmd = "Copilot",
    event = "InsertEnter",
    config = function()
      require "custom.configs.copilot"
    end,
  },
  -- formatters
  {
    "nvimtools/none-ls.nvim",
    ft = {"go"},
    event = "InsertEnter",
    opts = function()
      return require("custom.configs.none-ls")
    end
  },
}

return plugins

