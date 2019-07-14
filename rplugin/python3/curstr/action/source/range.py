

from typing import List  # noqa

from curstr.action.group import ActionGroup, Range

from .base import Source as Base


class Source(Base):

    def create(self) -> ActionGroup:
        separator = self.get_option('separator')
        if separator is None:
            separator = self._vim.call('input', 'Separator: ')

        return Range(
            self._vim, self._info.first_line, self._info.last_line, separator
        )

    def get_options(self):
        return {
            'separator': None,
        }
