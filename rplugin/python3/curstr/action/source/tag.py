

from typing import List  # noqa

from curstr.action.group import ActionGroup, Nothing, Tag, Tags
from curstr.custom import ActionSourceOption

from .base import ActionSource as Base


class ActionSource(Base):

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        word = self._vim.call('expand', '<cword>')

        contained = []  # type: List[str]
        append = contained.append
        for tag in self._vim.call('taglist', '.*{}.*'.format(word)):
            name = tag['name']
            if name == word:
                return Tag(self._vim, word)

            append(name)

        if not contained or option.get('exactly'):
            return Nothing(self._vim)

        return Tags(self._vim, contained)
