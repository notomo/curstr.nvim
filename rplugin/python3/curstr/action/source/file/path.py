
from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self) -> ActionGroup:
        path, position = self._cursor.get_file_path_with_position()
        absolute_path = self._vim.call('fnamemodify', path, ':p')

        return self._dispatcher.dispatch((
            (FileDispatcher.FilePosition, absolute_path, *position),
            (FileDispatcher.File, absolute_path)
        ))
