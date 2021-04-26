local M = {}

M.default_config = {
  sources = {},
  groups = {},
  source_aliases = {
    ["vim/runtime"] = {
      names = {
        "vim/runtime/pattern/file",
        "vim/runtime/pattern/directory",
        "vim/runtime/file",
        "vim/runtime/directory",
      },
    },
    file = {names = {"file/buffer_relative", "file/path"}},
    directory = {names = {"directory/buffer_relative", "directory/path"}},
    ["vim/function"] = {names = {"vim/autoload_function", "vim/script_function"}},
    ["lua"] = {names = {"vim/lua", "lua/luarocks"}},
  },
}

M.config = vim.deepcopy(M.default_config)

function M.set(config)
  M.config = vim.tbl_deep_extend("force", M.config, config)
end

return M
