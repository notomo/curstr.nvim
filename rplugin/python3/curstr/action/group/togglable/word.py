
from curstr.action.group import ActionGroup


class Word(ActionGroup):

    def __init__(
        self, vim, new_string: str, start: int, end: int
    ) -> None:
        super().__init__(vim)
        self._new_string = new_string
        self._start = start
        self._end = end

    @ActionGroup.action(modify=True)
    def toggle(self):
        new_line = self._make_new_line()
        line_number = self._vim.current.window.cursor[0] - 1
        self._vim.current.buffer[line_number] = new_line

    @ActionGroup.action(modify=True)
    def append(self):
        new_line = self._make_new_line()
        line_number = self._vim.current.window.cursor[0] - 1
        self._vim.current.buffer[line_number:line_number + 1] = [
            self._vim.current.line,
            new_line,
        ]

    def _make_new_line(self) -> str:
        line = self._vim.current.line
        return '{}{}{}'.format(
            line[:self._start],
            self._new_string,
            line[self._end:]
        )

    @ActionGroup.action(modify=True)
    def default(self):
        self.toggle()
