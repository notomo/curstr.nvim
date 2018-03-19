
from os.path import join

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self) -> ActionGroup:
        path = self._cursor.get_file_path()
        absolute_path = join(self._vim.call('expand', '%:p:h'), path)
        return self._dispatcher.dispatch_one(
            FileDispatcher.Directory,
            absolute_path
        )
