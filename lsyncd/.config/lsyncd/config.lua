local function hostname()
  local handle = io.popen("hostname")
  if not handle then return os.getenv("HOSTNAME") or "" end
  local name = handle:read("*l") or ""
  handle:close()
  return name
end

local TARGET = ({
  blackslate = os.getenv("HOME") .. "/shared/SDXC/sync/Projects",
  destro     = os.getenv("HOME") .. "/shared/UGREEN/sync/Projects",
})[hostname()]

if not TARGET then
  error("lsyncd: unknown hostname '" .. hostname() .. "', refusing to sync")
end

settings {
  logfile    = os.getenv("HOME") .. "/.config/lsyncd/lsyncd.log",
  statusFile = os.getenv("HOME") .. "/.config/lsyncd/lsyncd.status",
  nodaemon   = true,
}

sync {
  default.rsync,
  source = os.getenv("HOME") .. "/Projects",
  target = TARGET,
  delay  = 2,
  rsync  = {
    archive  = true,
    compress = false,
    acls     = true,
    xattrs   = true,
  }
}