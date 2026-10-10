-- Keymaps are automatically loaded on the VeryLazy event
-- Default keymaps that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/keymaps.lua
-- Add any additional keymaps here

-- 文字数カウント (本体 lua/charcount.lua は初回実行時に読み込む)
vim.keymap.set("n", "<leader>uk", function()
  require("charcount").toggle()
end, { desc = "Toggle Char Count" })
vim.api.nvim_create_user_command("CharCount", function(opts)
  require("charcount").command(opts.fargs)
end, { nargs = "*", desc = "文字数の目標を設定 (:CharCount [最低] 最大 | clear)" })
