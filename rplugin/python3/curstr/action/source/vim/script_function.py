
import re
from typing import Tuple

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source import Source as Base
from curstr.custom import SourceOption


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self, option: SourceOption) -> ActionGroup:
        try:
            self._vim.command('setlocal iskeyword+={}'.format(':,<,>'))
            cword = self._vim.call('expand', '<cword>')
        finally:
            self._vim.command('setlocal iskeyword-={}'.format(':,<,>'))

        position = self.__search_function_position(cword)
        return self._dispatcher.dispatch_one(
            FileDispatcher.Position,
            *position
        )

    def __search_function_position(self, name: str) -> Tuple[int, int]:
        match = re.match('(s:|<SID>)(?P<name>\S+)', name)
        if match is None:
            return (0, 0)
        function_name = match.group('name')
        return self._vim.call(
            'searchpos',
            '\\v\s*fu%[nction]!?\s*s:\zs{}\('.format(function_name),
            'nw'
        )
