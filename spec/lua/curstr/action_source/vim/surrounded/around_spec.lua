local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")
local assert = helper.typed_assert(assert)

describe("vim/surrounded/around", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  for _, c in ipairs({
    { str = " (hoge) ", column = 3, want = { "(hoge)" } },
    { str = " [hoge] ", column = 3, want = { "[hoge]" } },
    { str = " {hoge} ", column = 3, want = { "{hoge}" } },
    { str = " <hoge> ", column = 3, want = { "<hoge>" } },
    { str = " 'hoge' ", column = 3, want = { "'hoge'" } },
    { str = " `hoge` ", column = 3, want = { "`hoge`" } },
    { str = ' "hoge" ', column = 3, want = { '"hoge"' } },
    { str = " (a) ", column = 2, want = { "(a)" } },
    { str = ' "a" ', column = 2, want = { '"a"' } },
    { str = "('{hoge}')", column = 4, want = { "{hoge}" } },
    { str = [[(
hoge
foo
 )]], row = 2, column = 4, want = { "(", "hoge", "foo", " )" } },
  }) do
    it(("select %s on %s"):format(table.concat(c.want, "\n"), c.str), function()
      helper.set_lines(c.str)
      vim.api.nvim_win_set_cursor(0, { c.row or 1, c.column })

      local got = helper.selected(function()
        curstr.execute("vim/surrounded/around")
      end)
      assert.same(c.want, got)
    end)
  end
end)
