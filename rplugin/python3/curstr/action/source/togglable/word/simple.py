

from typing import List, Tuple

from curstr.action.group import ActionGroup
from curstr.action.group.togglable import Word
from curstr.action.source.base import Source as Base


class Source(Base):

    def create(self) -> ActionGroup:
        added_iskeyword = self.get_option('added_iskeyword')
        word, word_range = self._cursor.get_word_with_range(added_iskeyword)
        words = self.get_option('words')
        if self.get_option('normalized'):
            args = [
                ([w.lower() for w in words], word),
                ([w.upper() for w in words], word),
                ([w.capitalize() for w in words], word),
            ]
        else:
            args = [(words, word)]

        for ws, w in args:
            group, valid = self._get_word(ws, w, word_range)
            if valid:
                return group

        return self._dispatcher.nothing()

    def _get_word(
        self, words: List[str], word: str, word_range: Tuple[int, int]
    ):
        if word not in words:
            return self._dispatcher.nothing(), False

        new_word = words[(words.index(word) + 1) % len(words)]

        return Word(self._vim, new_word, *word_range), True

    def get_options(self):
        return {
            'words': [],
            'normalized': False,
            'added_iskeyword': '',
        }
