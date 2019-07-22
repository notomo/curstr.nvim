
import pathlib
from typing import List

from .listable import Listable


class Helps(Listable):

    def __init__(self, vim, words: List[str]) -> None:
        super().__init__(vim)
        self._words = words

    def name(self):
        return pathlib.Path(__file__).stem

    @Listable.action()
    def list(self):
        self._vim.call(
            'denite#start',
            [{'name': 'curstr/help', 'args': []}],
            {'curstr__targets': self._words}
        )
