
from typing import Tuple

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self) -> ActionGroup:
        path = self._cursor.get_file_path()

        source_patttern = self.get_option('source_pattern')
        result_pattern = self.get_option('result_pattern')
        replace_all = 'g' if self.get_option('replace_all') else ''
        applied = self._vim.call(
            'substitute', path, source_patttern, result_pattern, replace_all
        )

        search_pattern = self.get_option('search_pattern')
        search = self._vim.call(
            'substitute', path, source_patttern, search_pattern, replace_all
        )

        absolute_path = self._vim.call('fnamemodify', applied, ':p')
        position = self.__search_position(
            search, search_pattern, absolute_path
        )

        return self._dispatcher.dispatch((
            (FileDispatcher.FilePosition, absolute_path, *position),
            (FileDispatcher.File, absolute_path)
        ))

    def __search_position(
        self, search: str, search_pattern: str, path: str
    ) -> Tuple[int, int]:
        if search_pattern == '':
            return (0, 0)

        with open(path, 'r') as f:
            line = f.readline()
            row = 1
            while line:
                match = self._vim.call('matchstrpos', line.rstrip(), search)
                if not match[0] == '':
                    return (row, match[1] + 1)
                line = f.readline()
                row += 1

        return (0, 0)

    def get_options(self):
        return {
            'source_pattern': '',
            'result_pattern': '',
            'search_pattern': '',
            'replace_all': False,
        }
