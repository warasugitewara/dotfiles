return {
  {
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    dependencies = { "nvim-tree/nvim-web-devicons", "nvim-telescope/telescope.nvim" },
    config = function()
      local logo = [[
   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]
      logo = string.rep("\n", 2) .. logo .. "\n"

      require("dashboard").setup({
        theme = "hyper",
        hide = {
          statusline = false,
          tabline = false,
        },
        config = {
          header = vim.split(logo, "\n"),
          shortcut_hl = {},
          center = {
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Find  File",
              desc_hl = "String",
              key = "f",
              keymap = "SPC f f",
              key_hl = "Number",
              action = "Telescope find_files",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Find  Word",
              desc_hl = "String",
              key = "w",
              keymap = "SPC f w",
              key_hl = "Number",
              action = "Telescope live_grep",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Recent Files",
              desc_hl = "String",
              key = "r",
              keymap = "SPC f r",
              key_hl = "Number",
              action = "Telescope oldfiles",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "File Browser",
              desc_hl = "String",
              key = "e",
              keymap = "SPC f e",
              key_hl = "Number",
              action = "Oil",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "New File",
              desc_hl = "String",
              key = "n",
              keymap = "SPC f n",
              key_hl = "Number",
              action = "ene",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Config",
              desc_hl = "String",
              key = "c",
              keymap = "SPC f c",
              key_hl = "Number",
              action = "edit " .. vim.fn.stdpath("config") .. "/init.lua",
            },
            {
              icon = "󰒲 ",
              icon_hl = "Title",
              desc = "Lazy",
              desc_hl = "String",
              key = "l",
              keymap = "SPC f l",
              key_hl = "Number",
              action = "Lazy",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Terminal",
              desc_hl = "String",
              key = "t",
              keymap = "SPC f t",
              key_hl = "Number",
              action = "terminal",
            },
            {
              icon = "  ",
              icon_hl = "Title",
              desc = "Quit",
              desc_hl = "String",
              key = "q",
              keymap = "SPC f q",
              key_hl = "Number",
              action = "qa",
            },
          },
          footer = function()
            local stats = require("lazy").stats()
            local ms = (math.floor(stats.startuptime * 100 + 0.5) / 100)
            return { "⚡ Neovim loaded " .. stats.loaded .. "/" .. stats.count .. " plugins in " .. ms .. "ms" }
          end,
          shortcut = {},
        },
      })
    end,
  },
}
