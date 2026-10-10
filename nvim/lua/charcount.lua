-- 文字数カウント (lualine 表示)
-- config/keymaps.lua からキー押下時に初めて require される。起動時には読み込まれない。
local M = {}

local store_path = vim.fn.stdpath("data") .. "/charcount.json"

local enabled = false
local installed = false
---@type table<string, { min?: integer, max?: integer }>
local goals = {}
---@type table<integer, { tick: integer, chars: integer, nospace: integer }>
local cache = {}

local function load_goals()
  local f = io.open(store_path, "r")
  if not f then
    return
  end
  local text = f:read("*a")
  f:close()
  local ok, decoded = pcall(vim.json.decode, text)
  if ok and type(decoded) == "table" then
    goals = decoded
  end
end

local function save_goals()
  local f, err = io.open(store_path, "w")
  if not f then
    vim.notify("charcount: 目標を保存できません: " .. tostring(err), vim.log.levels.ERROR)
    return
  end
  f:write(vim.json.encode(goals))
  f:close()
end

---@param lines string[]
---@return integer chars, integer nospace
local function count(lines)
  local chars, spaces = 0, 0
  for _, line in ipairs(lines) do
    chars = chars + vim.fn.strchars(line)
    local _, half = line:gsub("[ \t]", "")
    local _, full = line:gsub("　", "")
    spaces = spaces + half + full
  end
  return chars, chars - spaces
end

---@param buf integer
---@return integer chars, integer nospace
local function count_buf(buf)
  local tick = vim.api.nvim_buf_get_changedtick(buf)
  local c = cache[buf]
  if not c or c.tick ~= tick then
    local chars, nospace = count(vim.api.nvim_buf_get_lines(buf, 0, -1, false))
    c = { tick = tick, chars = chars, nospace = nospace }
    cache[buf] = c
  end
  return c.chars, c.nospace
end

---@return string? mode
local function visual_mode()
  local mode = vim.fn.mode()
  if mode == "v" or mode == "V" or mode == "\22" then
    return mode
  end
end

---@param buf integer
---@return { min?: integer, max?: integer }?
local function goal_of(buf)
  local name = vim.api.nvim_buf_get_name(buf)
  if name ~= "" then
    return goals[name]
  end
  return vim.b[buf].charcount_goal
end

local function text()
  local mode = visual_mode()
  if mode then
    local chars, nospace = count(vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = mode }))
    return ("選択 %d字 (空白なし%d)"):format(chars, nospace)
  end
  local buf = vim.api.nvim_get_current_buf()
  local chars, nospace = count_buf(buf)
  local goal = goal_of(buf)
  local target = ""
  if goal and goal.min and goal.max then
    target = ("/%d-%d"):format(goal.min, goal.max)
  elseif goal and goal.max then
    target = ("/%d"):format(goal.max)
  end
  return ("%d%s字 (空白なし%d)"):format(chars, target, nospace)
end

local function color()
  if visual_mode() then
    return nil
  end
  local buf = vim.api.nvim_get_current_buf()
  local goal = goal_of(buf)
  if not goal then
    return nil
  end
  local chars = count_buf(buf)
  if goal.max and chars > goal.max then
    return { fg = Snacks.util.color("DiagnosticError") }
  elseif goal.min and chars < goal.min then
    return { fg = Snacks.util.color("DiagnosticWarn") }
  elseif goal.min then
    return { fg = Snacks.util.color("DiagnosticOk") }
  end
  return nil
end

-- lualine の現在の設定にコンポーネントを 1 度だけ差し込む。以降の ON/OFF は cond で切り替える。
local function install()
  local lualine = require("lualine")
  local config = lualine.get_config()
  table.insert(config.sections.lualine_x, 1, {
    text,
    cond = function()
      return enabled
    end,
    color = color,
  })
  lualine.setup(config)
  vim.api.nvim_create_autocmd("BufWipeout", {
    group = vim.api.nvim_create_augroup("charcount", { clear = true }),
    callback = function(ev)
      cache[ev.buf] = nil
    end,
  })
  installed = true
end

---@param state? boolean 省略時は反転
function M.toggle(state)
  if state == nil then
    state = not enabled
  end
  if state and not installed then
    install()
  end
  enabled = state
  if installed then
    require("lualine").refresh()
  end
end

--- :CharCount の実体
---   :CharCount            現在の目標を表示
---   :CharCount 800        最大 800 字
---   :CharCount 600 800    最低 600 字, 最大 800 字
---   :CharCount clear      目標を解除
---@param args string[]
function M.command(args)
  local buf = vim.api.nvim_get_current_buf()
  local name = vim.api.nvim_buf_get_name(buf)

  if #args == 0 then
    local goal = goal_of(buf)
    if goal then
      vim.notify(("charcount: 最低 %s / 最大 %s"):format(goal.min or "-", goal.max or "-"))
    else
      vim.notify("charcount: 目標は未設定です (:CharCount [最低] 最大)")
    end
    M.toggle(true)
    return
  end

  local goal
  if #args == 1 and args[1] == "clear" then
    goal = nil
  else
    local nums = vim.tbl_map(tonumber, args)
    local min, max
    if #args == 1 then
      max = nums[1]
    elseif #args == 2 then
      min, max = nums[1], nums[2]
    end
    local valid = max and max > 0 and max % 1 == 0 and (#args == 1 or (min and min >= 0 and min % 1 == 0 and min <= max))
    if not valid then
      vim.notify("charcount: 使い方 :CharCount [最低] 最大 | clear", vim.log.levels.ERROR)
      return
    end
    goal = { min = min, max = max }
  end

  if name ~= "" then
    goals[name] = goal
    save_goals()
  else
    -- 無名バッファは保存先のキーが無いのでセッション内のみ
    vim.b[buf].charcount_goal = goal
  end
  M.toggle(true)
end

load_goals()

return M
