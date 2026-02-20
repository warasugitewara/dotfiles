-- lua/plugins/nvim-scrollbar.lua
return {
  "petertriho/nvim-scrollbar",
  config = function()
    require("scrollbar").setup({
      show = true, -- スクロールバーを常に表示
      handle = { color = "#AAAAAA" },
      marks = {
        Cursor = { color = "#FF0000" }, -- カーソル位置マーク
        Search = { color = "#FFFF00" }, -- 検索結果マーク
        Error = { color = "#FF0000" },
        Warn = { color = "#FFA500" },
        Info = { color = "#00FFFF" },
        Hint = { color = "#00FF00" },
      },
    })
  end,
  dependencies = { "kevinhwang91/nvim-hlslens" }, -- optional: ハイライト lens が必要な場合
}
