

from typing import List  # noqa

from curstr.action.group import ActionGroup
from curstr.action.group.togglable import Word
from curstr.action.source.base import Source as Base


class Source(Base):

    def create(self) -> ActionGroup:
        word, word_range = self._cursor.get_word_with_range()
        patterns = self.get_option('patterns')

        for args in patterns:
            if len(args) == 3:
                pattern, new_pattern, option = args
            else:
                pattern, new_pattern = args
                option = 'g'

            if self._vim.call('match', word, pattern) != -1:
                new_word = self._vim.call(
                    'substitute', word, pattern, new_pattern, option
                )
                return Word(self._vim, new_word, *word_range)

        return self._dispatcher.nothing()

    def get_options(self):
        return {
            'patterns': [],
        }
