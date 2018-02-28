
import os.path
import re
from typing import Tuple

from curstr.action.group import ActionGroup, FilePosition, Nothing
from curstr.custom import ActionSourceOption
from curstr.action.source.file import ActionSource as FileActionSource


class ActionSource(FileActionSource):

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        try:
            self._vim.command('setlocal iskeyword+={}'.format('#'))
            cword = self._vim.call('expand', '<cword>')
        finally:
            self._vim.command('setlocal iskeyword-={}'.format('#'))

        if '#' not in cword:
            return Nothing(self._vim)

        splited = cword.split('#')
        paths = splited[:-1]
        path = '{}.vim'.format(os.path.join('', *paths))
        for runtimepath in self._vim.options['runtimepath'].split(','):
            file_path = os.path.join(runtimepath, 'autoload', path)
            if os.path.isfile(file_path):
                return self._get_file_action_group(
                    file_path,
                    self.__search_position(cword, file_path)
                )

        return Nothing(self._vim)

    def _get_file_action_group(
        self, path: str, position: Tuple[int, int]
    ) -> ActionGroup:
        file_action_group = self._get_action_group(path)
        if isinstance(file_action_group, Nothing) or position == (0, 0):
            return file_action_group
        return FilePosition(self._vim, file_action_group.path, *position)

    def __search_position(
        self, function_name: str, path: str
    ) -> Tuple[int, int]:
        with open(path, 'r') as f:
            line = f.readline()
            row = 1
            while line:
                match = re.match(
                    '\s*fu(nction)?!?\s*(?P<name>{})\('.format(function_name),
                    line
                )
                if match is not None:
                    return (row, match.start('name') + 1)
                line = f.readline()
                row += 1

        return (0, 0)
