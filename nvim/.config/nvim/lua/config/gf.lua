local M = {}

local function exists(path)
	return vim.loop.fs_stat(path) ~= nil
end

-- Build an ordered list of candidate paths, deduplicated.
local function dedup(list)
	local seen, out = {}, {}
	for _, c in ipairs(list) do
		if c ~= "" and not seen[c] then
			seen[c] = true
			out[#out + 1] = c
		end
	end
	return out
end

local function roots()
	local dir = vim.fn.expand("%:p:h")
	local list = { dir }
	for _, p in ipairs(vim.opt.path:get()) do
		local r = p:gsub("^%*%*", "")
		if r ~= "" then
			list[#list + 1] = r
		end
	end
	return list
end

local function resolve(candidates)
	for _, c in ipairs(candidates) do
		if exists(c) then
			return c
		end
	end
	return candidates[#candidates]
end

-- Perl module `Foo::Bar` -> Foo/Bar.pm (also handled by stock includeexpr,
-- this just makes `gf` search the current file's dir + 'path' for local modules).
function M.perl(fname)
	local rel = fname:gsub("::", "/") .. ".pm"
	local list = {}
	for _, r in ipairs(roots()) do
		list[#list + 1] = r .. "/" .. rel
		list[#list + 1] = r .. "/lib/" .. (fname:gsub("::", "/"))
	end
	return resolve(dedup(list))
end

-- Python module `foo.bar` -> foo/bar.py or foo/bar/__init__.py
function M.python(fname)
	local rel = fname:gsub("%.", "/")
	local list = {}
	for _, r in ipairs(roots()) do
		list[#list + 1] = r .. "/" .. rel .. ".py"
		list[#list + 1] = r .. "/" .. rel .. "/__init__.py"
	end
	return resolve(dedup(list))
end

-- Raku module `Foo::Bar` -> Foo/Bar.rakumod (also tried .pm6 / .pm).
function M.raku(fname)
	local rel = fname:gsub("::", "/")
	local list = {}
	for _, r in ipairs(roots()) do
		for _, ext in ipairs({ ".rakumod", ".pm6", ".pm" }) do
			list[#list + 1] = r .. "/" .. rel .. ext
			list[#list + 1] = r .. "/lib/" .. rel .. ext
		end
	end
	return resolve(dedup(list))
end

-- C/C++ header: strip <> / "" and append a header suffix if none present.
function M.c(fname)
	local base = fname:match("^<(.+)>$") or fname:match("^\"(.+)\"$") or fname
	local suffixed = { base }
	if not base:match("%.") then
		suffixed = {}
		for _, suf in ipairs({ ".h", ".hpp", ".hxx" }) do
			suffixed[#suffixed + 1] = base .. suf
		end
	end
	local list = {}
	for _, r in ipairs(roots()) do
		for _, c in ipairs(suffixed) do
			list[#list + 1] = r .. "/" .. c
		end
	end
	return resolve(dedup(list))
end

return M
