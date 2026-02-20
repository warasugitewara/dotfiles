return {
  "github/copilot.vim",
  event = "VeryLazy", -- 遅延ロード
  config = function()
    -- キーマッピングの設定: Ctrl + aで提案を受け入れる
    vim.keymap.set("i", "<C-a>", 'copilot#Accept("\\<CR>")', {
      expr = true,
      replace_keycodes = false,
    })
    -- Tabキーのデフォルトマッピングを無効化
    vim.g.copilot_no_tab_map = true
  end,
}
