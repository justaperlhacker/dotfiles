-- "kitty": vivid, plugin-aware highlighting from vague.nvim recolored with the
-- matching kitty theme (dark-theme.auto.conf / light-theme.auto.conf), plus the
-- Perl / POD / Raku groups that only kraihnight defines.
--
-- The palette is chosen by 'background', so `:colorscheme kitty` serves both
-- dark and light. Edit lua/config/kitty-palette.lua to point at other files.

local helper = require("config.kitty-palette")
local background = vim.o.background

-- vague's highlight modules capture its config table once, at require time, so
-- applying a different palette means reloading them (setup() alone would only
-- replace the table they no longer look at).
local function load_vague(colors)
  for name in pairs(package.loaded) do
    if name == "vague" or name:match("^vague%.") then
      package.loaded[name] = nil
    end
  end

  local vague = require("vague")
  if colors then
    vague.setup({ colors = colors })
  end
  return vague
end

local ok, vague = pcall(load_vague, helper.vague(background))
if not ok then
  -- vague is deferred to VeryLazy; make sure it is loaded before we use it.
  pcall(function()
    require("lazy").load({ plugins = { "vague" } })
  end)
  ok, vague = pcall(load_vague, helper.vague(background))
end

if not ok then
  vim.notify("[kitty] vague.nvim is unavailable; falling back to 'default'", vim.log.levels.ERROR)
  vim.cmd.colorscheme("default")
  return
end

if vague._colorscheme then
  vague._colorscheme()
else
  vim.cmd.colorscheme("vague")
end

-- vague only changes Visual's background, which leaves the normal foreground
-- sitting on a low-contrast tint and makes IncSearch nearly invisible. Use the
-- terminal's selection pair for every selection-style group instead.
local selection = helper.selection(background)
if selection then
  vim.api.nvim_set_hl(0, "Visual", { bg = selection.bg, fg = selection.fg })
  vim.api.nvim_set_hl(0, "VisualNOS", { bg = selection.bg, fg = selection.fg })
  vim.api.nvim_set_hl(0, "Search", { bg = selection.bg, fg = selection.fg })
  vim.api.nvim_set_hl(0, "IncSearch", { bg = selection.fg, fg = selection.bg, bold = true })
  vim.api.nvim_set_hl(0, "CurSearch", { bg = selection.fg, fg = selection.bg, bold = true })
  vim.api.nvim_set_hl(0, "MatchParen", { bg = selection.bg, fg = selection.fg, bold = true })
end

-- Kraihnight is the only place the legacy Perl/POD/Raku groups are defined.
-- Lift just those lines out of it and recolor them like everything else.
local map = helper.kraihnight(background)
if map then
  local lines = vim.fn.readfile(vim.fn.stdpath("config") .. "/colors/kraihnight.lua")
  local perl = {}
  for _, line in ipairs(lines) do
    local group = line:match("^hi%('([%w_]+)'")
    if group and (group:match("^perl") or group:match("^pod") or group:match("^raku")) then
      perl[#perl + 1] = line
    end
  end

  if #perl > 0 then
    local source = table.concat({
      "local function hi(group, opts) vim.api.nvim_set_hl(0, group, opts) end",
      table.concat(perl, "\n"),
    }, "\n")
    source = source:gsub("'(#[%x]+)'", function(color)
      return "'" .. (map[color:lower()] or color) .. "'"
    end)

    local loader = loadstring or load
    local chunk, err = loader(source, "@kitty-perl")
    if chunk then
      chunk()
    else
      vim.notify("[kitty] Perl/Raku highlights failed: " .. tostring(err), vim.log.levels.WARN)
    end
  end
end

vim.g.colors_name = "kitty"
