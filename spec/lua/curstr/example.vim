lua << EOF
require("curstr").setup({
  source_aliases = {
    openable = {names = {"vim/function", "lua", "file", "directory", "vim/runtime"}},
  },
  sources = {
    ["vim/autoload_function"] = {
      opts = {include_packpath = true},
      filetypes = {"vim", "python", "lua"},
    },
  },
})
EOF

nnoremap gf <Cmd>lua require("curstr").execute("openable")<CR>
nnoremap gF <Cmd>lua require("curstr").execute("openable", {action = "vertical_open"})<CR>
