local M = {}

M.sources = {}
M.groups = {}

M.source_aliases = {}
M.source_aliases["vim/runtime"] = {
  names = {
    "vim/runtime/pattern/file",
    "vim/runtime/pattern/directory",
    "vim/runtime/file",
    "vim/runtime/directory",
  },
}
M.source_aliases.file = {names = {"file/buffer_relative", "file/path"}}
M.source_aliases.directory = {names = {"directory/buffer_relative", "directory/path"}}
M.source_aliases["vim/function"] = {names = {"vim/autoload_function", "vim/script_function"}}

return M
