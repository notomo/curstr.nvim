
from neovim import Nvim

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

    @File.action()
    def open(self):
        super().open()
        self._goto()

    @File.action()
    def tab_open(self):
        super().tab_open()
        self._goto()

    @File.action()
    def vertical_open(self):
        super().vertical_open()
        self._goto()

    @File.action()
    def horizontal_open(self):
        super().horizontal_open()
        self._goto()

    def _goto(self):
        self._vim.call('cursor', self._row, self._column)
