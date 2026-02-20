
-- lua/plugins/cord.lua
return {
  "vyfor/cord.nvim",
  event = "VeryLazy",
  config = function()
    require("cord").setup({
      display = {
        theme = "default",
        flavor = "dark",
        view = "full",
      },
      text = {
        viewing = function(opts)
          return "Viewing " .. opts.filename
        end,
        editing = function(opts)
          return "Editing " .. opts.filename
        end,
        workspace = function(opts)
          return "Working in " .. opts.workspace
        end,
      },
      -- buttons = {
      --   {
      --     label = "View Repository",
      --     url = function(opts)
      --       return opts.repo_url
      --     end,
      --   },
      -- },
    })
  end,
}
