
import pathlib

from .file import File
from .listable import Listable


class Directory(File, Listable):

    def __init__(self, vim, path) -> None:
        super().__init__(vim, path)

    def name(self):
        return pathlib.Path(__file__).stem

    @Listable.action()
    def list(self):
        self._vim.call(
            'denite#start',
            [{'name': 'curstr/file', 'args': []}],
            {'curstr__path': self._path}
        )
