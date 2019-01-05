
import os.path
import re
from typing import Tuple

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source import Source as Base


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self) -> ActionGroup:
        cword = self._cursor.get_word(added_iskeyword='#')

        if '#' not in cword:
            return self._dispatcher.nothing()

        splited = cword.split('#')
        paths = splited[:-1]
        path = '{}.vim'.format(os.path.join('', *paths))
        for runtimepath in self._vim.options['runtimepath'].split(','):
            file_path = os.path.join(runtimepath, 'autoload', path)
            if os.path.isfile(file_path):
                position = self.__search_position(cword, file_path)
                return self._dispatcher.dispatch((
                    (FileDispatcher.FilePosition, file_path, *position),
                    (FileDispatcher.File, file_path)
                ))

        return self._dispatcher.nothing()

    def __search_position(
        self, function_name: str, path: str
    ) -> Tuple[int, int]:
        with open(path, 'r') as f:
            line = f.readline()
            row = 1
            while line:
                match = re.match(
                    '\\s*fu(nction)?!?\\s*(?P<name>{})\\('.format(
                        function_name
                    ),
                    line
                )
                if match is not None:
                    return (row, match.start('name') + 1)
                line = f.readline()
                row += 1

        return (0, 0)

    def get_options(self):
        return {
            'filetyps': ['vim'],
        }
