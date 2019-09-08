from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self) -> ActionGroup:
        path = self._cursor.get_file_path()
        absolute_path = self._vim.call("fnamemodify", path, ":p")
        return self._dispatcher.dispatch_one(FileDispatcher.Directory, absolute_path)
