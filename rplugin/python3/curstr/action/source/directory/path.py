
from curstr.action.group import ActionGroup, Directory, FileDispatcher
from curstr.action.source.base import Source as Base
from curstr.custom import SourceOption


class Source(Base):

    _DISPATCHER_CLASS = FileDispatcher

    def create(self, option: SourceOption) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')
        absolute_path = self._vim.call('fnamemodify', path, ':p')
        return self._dispatcher.dispatch_one(Directory, absolute_path)
