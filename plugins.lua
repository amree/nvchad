local plugins = {
  {
    "williamboman/mason.nvim",
    opts = {
      ensure_installed = {
        "gopls",
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
  }

}

return plugins
