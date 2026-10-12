-- Persistent workspaces (portable: no monitor binding, so this works on the
-- 2-monitor host and the single-monitor target alike).

local names = { "web", "code", "chat", "media", "game", "six", "seven", "eight", "nine" }

for i = 1, 9 do
  hl.workspace_rule({
    workspace = tostring(i),
    persistent = true,
    default_name = names[i],
  })
end
