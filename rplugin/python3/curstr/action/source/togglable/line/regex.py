

from typing import List  # noqa

from curstr.action.group import ActionGroup
from curstr.action.group.togglable import Line
from curstr.action.source.base import Source as Base


class Source(Base):

    def create(self) -> ActionGroup:
        line = self._cursor.get_line()
        patterns = self.get_option('patterns')

        for args in patterns:
            if len(args) == 3:
                pattern, new_pattern, option = args
            else:
                pattern, new_pattern = args
                option = 'g'

            if self._vim.call('match', line, pattern) != -1:
                new_line = self._vim.call(
                    'substitute', line, pattern, new_pattern, option
                )
                return Line(self._vim, new_line)

        return self._dispatcher.nothing()

    def get_options(self):
        return {
            'patterns': [],
        }
