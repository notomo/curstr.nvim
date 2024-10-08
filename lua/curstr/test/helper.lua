local helper = require("vusted.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("vusted.assert").register)

local runtimepath = vim.o.runtimepath

function helper.before_each()
  helper.test_data = require("curstr.vendor.misclib.test.data_dir").setup(helper.root)
  helper.test_data:cd("")
  vim.o.runtimepath = runtimepath
end

function helper.after_each()
  helper.cleanup()
  helper.cleanup_loaded_modules(plugin_name)
  helper.test_data:teardown()
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
    local lines = table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n")
    local msg = ("on %s: `%s` not found in buffer:\n%s"):format(pos, pattern, lines)
    assert(false, msg)
  end
  return result
end

function helper.open_new_file(path, content)
  helper.test_data:create_file(path, content)
  vim.cmd.edit(helper.test_data:path(path))
end

function helper.add_packpath(path)
  vim.opt.packpath:prepend(vim.fn.fnamemodify(helper.test_data:path(path), ":p"))
end

function helper.selected(f)
  vim.api.nvim_feedkeys("v", "tx", true)
  f()
  return vim.fn.getregion(vim.fn.getpos("v"), vim.fn.getpos("."), { type = "v" })
end

local asserts = require("vusted.assert").asserts

asserts.create("path"):register_eq(function()
  return vim.fn.expand("%:p"):gsub(helper.root .. "/" .. "?", "")
end)

asserts.create("current_dir"):register_eq(function()
  return vim.fn.getcwd():gsub(helper.test_data:path("?"), "")
end)

function helper.typed_assert(assert)
  local x = require("assertlib").typed(assert)
  ---@cast x +{path:fun(want),current_dir:fun(want)}
  return x
end

return helper
