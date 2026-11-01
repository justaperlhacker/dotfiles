-- Time-based dark/light background switching.
--
-- Dark between sunset and sunrise, computed locally from latitude/longitude --
-- no desktop portal, gsettings, or other external dependency. A timer
-- re-evaluates the clock every 30 seconds, which also recovers from
-- suspend/resume, DST changes and timezone changes.
--
--   M.detect()   -> "dark" | "light"
--   M.start()    -> "dark" | "light"  (detect + start the clock)
--   M.set(bg)    -> set 'background', fire User BackgroundChanged
--   M.lock()     -> stop following the clock (manual choice wins)
--   M.follow()   -> resume following the clock
--   M.sun_times()-> sunrise, sunset (fractional local hours) or nil, nil, polar

local M = {}

-- Set while we change 'background' ourselves, so listeners can tell our
-- updates apart from a user/plugin changing the option directly.
M.internal = false

M.options = {
  -- Montreal; the same coordinates live in ~/.config/redshift/redshift.conf.
  latitude = 45.501,
  longitude = -73.593,
  -- Use fixed clock times ("HH:MM") instead of the sun. Set both or neither;
  -- e.g. light_at = "07:30", dark_at = "18:00".
  light_at = nil,
  dark_at = nil,
  -- Seconds between clock checks. Pure arithmetic, so cheap.
  interval = 120,
}

local following = true
local timer

M.options.latitude = tonumber(M.options.latitude) or 0
M.options.longitude = tonumber(M.options.longitude) or 0

local function parse_clock(value)
  local hour, minute = tostring(value or ""):match("^(%d%d?):(%d%d)$")
  if not hour then
    return nil
  end
  return tonumber(hour) * 60 + tonumber(minute)
end

-- NOAA sunrise/sunset algorithm (zenith 90.833 deg, i.e. sunset proper).
-- Returns fractional *local* hours for the given day of year. When the sun
-- never rises or sets, returns nil, nil plus "night" or "day".
local function solar_times(yday)
  local latitude = M.options.latitude
  local longitude = M.options.longitude

  if latitude == 0 and longitude == 0 then
    return nil, nil, "night"
  end

  local lng_hour = longitude / 15

  local function event(is_sunrise)
    local t = yday + ((is_sunrise and 6 or 18) - lng_hour) / 24
    local m = (0.9856 * t) - 3.289
    local l = m + (1.916 * math.sin(math.rad(m))) + (0.020 * math.sin(math.rad(2 * m))) + 282.634
    l = l % 360

    local ra = math.deg(math.atan(0.91764 * math.tan(math.rad(l)))) % 360
    local l_quadrant = math.floor(l / 90) * 90
    local ra_quadrant = math.floor(ra / 90) * 90
    ra = (ra + (l_quadrant - ra_quadrant)) % 360 / 15

    local sin_dec = 0.39782 * math.sin(math.rad(l))
    local cos_dec = math.cos(math.asin(sin_dec))
    local cos_h = (math.cos(math.rad(90.833)) - (sin_dec * math.sin(math.rad(latitude))))
      / (cos_dec * math.cos(math.rad(latitude)))

    if cos_h > 1 then
      return nil, "night"
    elseif cos_h < -1 then
      return nil, "day"
    end

    local h = math.acos(cos_h)
    if is_sunrise then
      h = (2 * math.pi) - h
    end
    h = math.deg(h) / 15

    local utc = (h + ra - (0.06571 * t) - 6.622 - lng_hour) % 24
    return utc
  end

  local sunrise_utc, sunrise_polar = event(true)
  local sunset_utc, sunset_polar = event(false)
  if not sunrise_utc or not sunset_utc then
    return nil, nil, sunrise_polar or sunset_polar
  end

  -- Convert UTC to local clock time. (os.date("!*t") is not usable here:
  -- os.time() would read its isdst=false and pretend DST is off.)
  local sign, hours, minutes = os.date("%z"):match("^([+-])(%d%d)(%d%d)$")
  local offset = 0
  if sign then
    offset = (tonumber(hours) + tonumber(minutes) / 60) * (sign == "-" and -1 or 1)
  end
  return (sunrise_utc + offset) % 24, (sunset_utc + offset) % 24
end

function M.sun_times()
  return solar_times(os.date("*t").yday)
end

function M.detect()
  local now = os.date("*t")
  local minutes = now.hour * 60 + now.min + now.sec / 60

  local light_at = parse_clock(M.options.light_at)
  local dark_at = parse_clock(M.options.dark_at)
  if light_at and dark_at then
    local light
    if light_at <= dark_at then
      light = minutes >= light_at and minutes < dark_at
    else
      light = minutes >= light_at or minutes < dark_at
    end
    return light and "light" or "dark"
  end

  local sunrise, sunset, polar = solar_times(now.yday)
  if not sunrise or not sunset then
    return polar == "day" and "light" or "dark"
  end
  local hour = minutes / 60
  return (hour < sunrise or hour >= sunset) and "dark" or "light"
end

function M.set(bg)
  if bg ~= "dark" and bg ~= "light" then
    return
  end

  if vim.o.background ~= bg then
    M.internal = true
    vim.o.background = bg
    M.internal = false
  end

  vim.api.nvim_exec_autocmds("User", { pattern = "BackgroundChanged" })
end

local function refresh()
  if not following then
    return
  end
  local bg = M.detect()
  if bg ~= vim.o.background then
    M.set(bg)
  end
end

local function start_timer()
  if timer then
    return
  end
  timer = vim.uv.new_timer()
  timer:start(1000, M.options.interval * 1000, vim.schedule_wrap(refresh))
end

local function stop_timer()
  if timer then
    timer:stop()
    timer:close()
    timer = nil
  end
end

function M.lock()
  following = false
end

function M.follow()
  following = true
  refresh()
end

function M.is_following()
  return following
end

function M.start()
  local bg = M.detect()

  M.internal = true
  vim.o.background = bg
  M.internal = false

  start_timer()

  vim.api.nvim_create_autocmd("VimLeavePre", {
    group = vim.api.nvim_create_augroup("ConfigAutoBackground", { clear = true }),
    callback = function()
      following = false
      stop_timer()
    end,
  })

  return bg
end

return M
