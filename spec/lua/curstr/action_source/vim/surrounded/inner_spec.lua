local helper = require("curstr.test.helper")
local curstr = helper.require("curstr")

describe("vim/surrounded/inner", function()
  before_each(helper.before_each)
  after_each(helper.after_each)

  it("can pass targets", function()
    helper.set_lines([[a hoge b]])
    vim.api.nvim_win_set_cursor(0, { 1, 4 })

    local got = helper.selected(function()
      curstr.execute("vim/surrounded/inner", {
        source_opts = {
          targets = {
            { s = "a", e = "b" },
          },
        },
      })
    end)
    assert.is_same({ " hoge " }, got)
  end)

  for _, c in ipairs({
    { str = "(hoge)", column = 1, want = { "hoge" } },
    { str = "[hoge]", column = 1, want = { "hoge" } },
    { str = "{hoge}", column = 1, want = { "hoge" } },
    { str = "<hoge>", column = 1, want = { "hoge" } },
    { str = "'hoge'", column = 1, want = { "hoge" } },
    { str = "`hoge`", column = 1, want = { "hoge" } },
    { str = '"hoge"', column = 1, want = { "hoge" } },
    { str = "(a)", column = 1, want = { "a" } },
    { str = '"a"', column = 1, want = { "a" } },
    { str = "('{hoge}')", column = 4, want = { "hoge" } },
    { str = [[(
hoge
foo
 )]], row = 2, column = 4, want = { "", "hoge", "foo", " " } },
  }) do
    it(("select %s on %s"):format(table.concat(c.want, "\n"), c.str), function()
      helper.set_lines(c.str)
      vim.api.nvim_win_set_cursor(0, { c.row or 1, c.column })

      local got = helper.selected(function()
        curstr.execute("vim/surrounded/inner")
      end)
      assert.is_same(c.want, got)
    end)
  end
end)
