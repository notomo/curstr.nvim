
import os.path
from typing import List  # noqa

from curstr.action.group import ActionGroup, Help, Helps, Nothing
from curstr.action.source import Source as Base
from curstr.custom import SourceOption


class Source(Base):

    def create(self, option: SourceOption) -> ActionGroup:
        word = self._vim.call('expand', '<cword>')

        contained = []  # type: List[str]
        extend = contained.extend
        for path in self._vim.options['runtimepath'].split(','):
            file_path = os.path.join(path, 'doc/tags')
            if not os.path.isfile(file_path):
                continue

            with open(file_path, 'r') as lines:
                words = [x.split('\t')[0] for x in lines]
                matched = [x for x in words if x == word]
                if matched:
                    return Help(self._vim, matched.pop())

                extend([x for x in words if word in x])

        if not contained or option.get('exactly'):
            return Nothing(self._vim)

        return Helps(self._vim, contained)
