local helper = require("ntf.helper")
local plugin_name = helper.get_module_root(...)

helper.root = helper.find_plugin_root(plugin_name)
vim.opt.packpath:prepend(vim.fs.joinpath(helper.root, "spec/.shared/packages"))
require("assertlib").register(require("ntf.assert").register)

local runtimepath = vim.o.runtimepath

function helper.before_each()
  helper.test_data = require("curstr.vendor.misclib.test.data_dir").setup(vim.fs.joinpath(helper.root, "spec"))
  helper.test_data:cd("")
  vim.o.runtimepath = runtimepath
  -- The data dir lives under spec/, so add it to runtimepath for the
  -- vim/runtime/* sources that resolve names via nvim_get_runtime_file.
  vim.opt.runtimepath:append(vim.fs.joinpath(helper.root, "spec"))
end

function helper.after_each()
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

local assert = require("ntf.assert")

assert.register_eq("path", function()
  return vim.fn.expand("%:p"):gsub(helper.root .. "/spec/" .. "?", "")
end)

assert.register_eq("current_dir", function()
  return vim.fn.getcwd():gsub(helper.test_data:path("?"), "")
end)

function helper.typed_assert(raw_assert)
  local x = require("assertlib").typed(raw_assert)
  ---@cast x +{path:fun(want),current_dir:fun(want)}
  return x
end

return helper
