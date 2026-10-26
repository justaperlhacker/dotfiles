local M = {}

local c_exts = { c = true }
local cpp_exts = { cpp = true, cc = true, cxx = true, ["c++"] = true }

local term ---@type snacks.win?

local function notify(msg, level)
  vim.notify(msg, level or vim.log.levels.WARN)
end

local function file()
  local name = vim.api.nvim_buf_get_name(0)
  if name == "" or vim.bo.buftype ~= "" then
    return nil
  end
  return name
end

local function lang()
  local name = file()
  if not name then
    return nil
  end
  local ext = vim.fn.fnamemodify(name, ":e"):lower()
  if ext == "pl" or ext == "pm" or ext == "t" then
    return "perl"
  elseif c_exts[ext] then
    return "c"
  elseif cpp_exts[ext] then
    return "cpp"
  end
  return nil
end

local function root()
  return vim.fs.root(0, {
    "Makefile.PL",
    "Makefile",
    "CMakeLists.txt",
    "meson.build",
    "build.sh",
    ".git",
  }) or vim.fn.getcwd()
end

local function in_dir(dir, cmd)
  return "cd " .. vim.fn.shellescape(dir) .. " && " .. cmd
end

local function run(cmd)
  if term then
    if term:win_valid() then
      pcall(function() term:close() end)
    end
    if term:buf_valid() then
      pcall(vim.api.nvim_buf_delete, term.buf, { force = true })
    end
    term = nil
  end
  term = Snacks.terminal.open(cmd, {
    count = 1,
    auto_close = false,
    win = { position = "bottom" },
  })
end

local function cc_cmd(with_debug)
  local src = vim.fn.shellescape(file())
  local compiler = lang() == "c" and "gcc" or "g++"
  local out = vim.fn.fnamemodify(file(), ":r") .. (with_debug and "_debug" or "")
  local flags = with_debug and "-g -O0 -Wall -Wextra" or "-O2 -Wall -Wextra"
  local cmd = ("%s %s -o %s %s"):format(compiler, flags, vim.fn.shellescape(out), src)
  return cmd, out
end

local function perl_cmd(check)
  local flags = "-Ilib"
  local r = root()
  if vim.fn.isdirectory(r .. "/t/lib") == 1 then
    flags = flags .. " -It/lib"
  end
  if check then
    flags = "-c " .. flags
  end
  return ("perl %s %s"):format(flags, vim.fn.shellescape(file()))
end

local function compile()
  local l = lang()
  if l == "perl" then
    run(perl_cmd(true))
  elseif l then
    run((cc_cmd(false)))
  else
    notify("No compiler for this file type")
  end
end

local function compile_debug()
  local l = lang()
  if l == "perl" then
    notify("Debug builds are only available for C/C++")
  elseif l then
    run((cc_cmd(true)))
  else
    notify("No compiler for this file type")
  end
end

local function run_current()
  local l = lang()
  if l == "perl" then
    if vim.fn.fnamemodify(file(), ":e") == "t" then
      run(in_dir(root(), "prove -lv " .. vim.fn.shellescape(file())))
    else
      run(perl_cmd())
    end
  elseif l then
    local cmd, out = cc_cmd(false)
    run(cmd .. " && " .. vim.fn.shellescape(out))
  else
    notify("Nothing to run for this file type")
  end
end

local function build()
  local r = root()
  local cmd
  if vim.fn.filereadable(r .. "/Makefile.PL") == 1 then
    cmd = "perl Makefile.PL && make"
  elseif vim.fn.filereadable(r .. "/build.sh") == 1 then
    cmd = "./build.sh"
  elseif vim.fn.filereadable(r .. "/Makefile") == 1 then
    cmd = "make"
  elseif vim.fn.filereadable(r .. "/CMakeLists.txt") == 1 then
    cmd = "cmake -S . -B build && cmake --build build"
  elseif vim.fn.filereadable(r .. "/meson.build") == 1 then
    cmd = "meson setup build && meson compile -C build"
  end
  if not cmd then
    notify("No build system found")
    return
  end
  run(in_dir(r, cmd))
end

local function test()
  local l = lang()
  local r = root()
  if l == "perl" or vim.fn.filereadable(r .. "/Makefile.PL") == 1 then
    if file() and vim.fn.fnamemodify(file(), ":e") == "t" then
      run(in_dir(r, "prove -lv " .. vim.fn.shellescape(file())))
    elseif vim.fn.isdirectory(r .. "/t") == 1 then
      run(in_dir(r, "prove -l t"))
    else
      run(in_dir(r, "prove -l"))
    end
    return
  end
  if vim.fn.filereadable(r .. "/CMakeLists.txt") == 1 then
    run(in_dir(r, "([ -d build ] || cmake -S . -B build) && cmake --build build && ctest --test-dir build --output-on-failure"))
  elseif vim.fn.filereadable(r .. "/Makefile") == 1 then
    run(in_dir(r, "make test"))
  else
    notify("No test runner found")
  end
end

vim.keymap.set("n", "<leader>cc", compile, { desc = "Compile / syntax check" })
vim.keymap.set("n", "<leader>cb", build, { desc = "Build project" })
vim.keymap.set("n", "<leader>cd", compile_debug, { desc = "Compile with debug symbols" })
vim.keymap.set("n", "<leader>cr", run_current, { desc = "Run" })
vim.keymap.set("n", "<leader>ct", test, { desc = "Run tests" })

return M
