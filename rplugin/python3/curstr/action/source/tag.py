

from typing import List  # noqa

from curstr.action.group import ActionGroup, Tag, Tags

from .base import Source as Base


class Source(Base):

    def create(self) -> ActionGroup:
        word = self._cursor.get_word()

        contained = []  # type: List[str]
        append = contained.append
        for tag in self._vim.call('taglist', '.*{}.*'.format(word)):
            name = tag['name']
            if name == word:
                return Tag(self._vim, word)

            append(name)

        if not contained or self._option.get('exactly'):
            return self._dispatcher.nothing()

        return Tags(self._vim, contained)
