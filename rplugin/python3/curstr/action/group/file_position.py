
from neovim.api.nvim import Nvim

from .file import File


class FilePosition(File):

    def __init__(self, vim: Nvim, path: str, row: int, column: int) -> None:
        super().__init__(vim, path)
        self._row = row
        self._column = column

    @property
    def row(self):
        return self._row

    @property
    def column(self):
        return self._column

    def action_open(self):
        super().action_open()
        self._goto()

    def action_tab_open(self):
        super().action_tab_open()
        self._goto()

    def action_vertical_open(self):
        super().action_vertical_open()
        self._goto()

    def action_horizontal_open(self):
        super().action_horizontal_open()
        self._goto()

    def _goto(self):
        self._vim.call('cursor', self._row, self._column)
