
from typing import List

from .listable import Listable


class Tags(Listable):

    def __init__(self, vim, words: List[str]) -> None:
        super().__init__(vim)
        self._words = words

    def action_list(self):
        self._vim.call(
            'denite#start',
            [{'name': 'curstr/tag', 'args': []}],
            {'curstr__targets': self._words}
        )
