
from curstr.action.group import ActionGroup


class Line(ActionGroup):

    def __init__(
        self, vim, new_string: str
    ) -> None:
        super().__init__(vim)
        self._new_string = new_string

    @ActionGroup.action()
    def toggle(self):
        line_number = self._vim.current.window.cursor[0] - 1
        self._vim.current.buffer[line_number] = self._new_string

    @ActionGroup.action()
    def append(self):
        line_number = self._vim.current.window.cursor[0] - 1
        self._vim.current.buffer[line_number:line_number + 1] = [
            self._vim.current.line,
            self._new_string,
        ]

    @ActionGroup.action()
    def default(self):
        self.toggle()