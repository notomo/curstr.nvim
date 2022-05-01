local plugin_name = vim.split((...):gsub("%.", "/"), "/", true)[1]
local helper = require("vusted.helper")

helper.root = helper.find_plugin_root(plugin_name)

local packpath = vim.o.packpath
local runtimepath = vim.o.runtimepath

function helper.before_each()
  vim.cmd("filetype on")
  vim.cmd("syntax enable")
  helper.test_data = require("curstr.vendor.misclib.test.data_dir").setup(helper.root)
  helper.test_data:cd("")
  vim.o.packpath = packpath
  vim.o.runtimepath = runtimepath
end

function helper.after_each()
  vim.cmd("silent! %bwipeout!")
  vim.cmd("filetype off")
  vim.cmd("syntax off")
  print(" ")

  helper.cleanup_loaded_modules(plugin_name)
  helper.test_data:teardown()
end

function helper.buffer_log()
  local lines = vim.fn.getbufline("%", 1, "$")
  for _, line in ipairs(lines) do
    print(line)
  end
end

function helper.set_lines(lines)
  vim.bo.buftype = "nofile"
  vim.api.nvim_buf_set_lines(0, 0, -1, false, vim.split(lines, "\n"))
end

function helper.search(pattern)
  local result = vim.fn.search(pattern)
  if result == 0 then
    local info = debug.getinfo(2)
    local pos = ("%s:%d"):format(info.source, info.currentline)
    local lines = table.concat(vim.fn.getbufline("%", 1, "$"), "\n")
    local msg = ("on %s: `%s` not found in buffer:\n%s"):format(pos, pattern, lines)
    assert(false, msg)
  end
  return result
end

function helper.open_new_file(path, content)
  helper.test_data:create_file(path, content)
  vim.cmd("edit " .. helper.test_data.full_path .. path)
end

function helper.window_count()
  return vim.fn.tabpagewinnr(vim.fn.tabpagenr(), "$")
end

function helper.add_packpath(path)
  vim.cmd("set packpath^=" .. vim.fn.fnamemodify(helper.test_data.full_path .. path, ":p"))
end

local asserts = require("vusted.assert").asserts

asserts.create("window"):register_eq(function()
  return vim.api.nvim_get_current_win()
end)

asserts.create("window_count"):register_eq(function()
  return helper.window_count()
end)

asserts.create("current_line"):register_eq(function()
  return vim.fn.getline(".")
end)

asserts.create("register_value"):register_eq(function(name)
  return vim.fn.getreg(name)
end)

asserts.create("line_count"):register_eq(function()
  return vim.api.nvim_buf_line_count(0)
end)

asserts.create("current_window"):register_eq(function()
  return vim.api.nvim_get_current_win()
end)

asserts.create("current_row"):register_eq(function()
  return vim.fn.line(".")
end)

asserts.create("current_column"):register_eq(function()
  return vim.fn.col(".")
end)

asserts.create("tab_count"):register_eq(function()
  return vim.fn.tabpagenr("$")
end)

asserts.create("file_name"):register_eq(function()
  return vim.fn.fnamemodify(vim.fn.bufname("%"), ":t")
end)

asserts.create("filetype"):register_eq(function()
  return vim.bo.filetype
end)

asserts.create("path"):register_eq(function()
  return vim.fn.expand("%:p"):gsub(helper.root .. "/" .. "?", "")
end)

asserts.create("cursor_word"):register_eq(function()
  return vim.fn.expand("<cword>")
end)

asserts.create("current_dir"):register_eq(function()
  return vim.fn.getcwd():gsub(helper.test_data.full_path .. "?", "")
end)

asserts.create("exists_pattern"):register(function(self)
  return function(_, args)
    local pattern = args[1]
    local result = vim.fn.search(pattern, "n")
    self:set_positive(("`%s` not found"):format(pattern))
    self:set_negative(("`%s` found"):format(pattern))
    return result ~= 0
  end
end)

asserts.create("exists_message"):register(function(self)
  return function(_, args)
    local expected = args[1]
    self:set_positive(("`%s` not found message"):format(expected))
    self:set_negative(("`%s` found message"):format(expected))
    local messages = vim.split(vim.api.nvim_exec("messages", true), "\n")
    for _, msg in ipairs(messages) do
      if msg:match(expected) then
        return true
      end
    end
    return false
  end
end)

asserts.create("error_message"):register(function(self)
  return function(_, args)
    local expected = args[1]
    local f = args[2]
    local ok, actual = pcall(f)
    if ok then
      self:set_positive("should be error")
      self:set_negative("should be error")
      return false
    end
    self:set_positive(("error message should end with '%s', but actual: '%s'"):format(expected, actual))
    self:set_negative(("error message should not end with '%s', but actual: '%s'"):format(expected, actual))
    return vim.endswith(actual, expected)
  end
end)

asserts.create("completion_contains"):register(function(self)
  return function(_, args)
    local result = args[1]
    local expected = args[2]
    local names = vim.split(result, "\n", true)
    self:set_positive(('completion should contain "%s", but actual: %s'):format(expected, vim.inspect(names)))
    self:set_negative(('completion should not contain "%s", but actual: %s'):format(expected, vim.inspect(names)))
    for _, name in ipairs(names) do
      if name == expected then
        return true
      end
    end
    return false
  end
end)

return helper
