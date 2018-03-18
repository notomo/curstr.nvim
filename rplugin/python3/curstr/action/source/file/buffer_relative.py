
from os.path import join

from curstr.action.group import ActionGroup, FileDispatcher
from curstr.action.source.base import Source as Base
from curstr.custom import SourceOption


class Source(Base):

    DISPATCHER_CLASS = FileDispatcher

    def create(self, option: SourceOption) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')
        absolute_path = join(self._vim.call('expand', '%:p:h'), path)
        return self._dispatcher.dispatch_one(
            FileDispatcher.File,
            absolute_path
        )
