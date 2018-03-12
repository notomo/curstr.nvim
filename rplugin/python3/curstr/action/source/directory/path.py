
from curstr.action.group import ActionGroup, Directory, FileDispatcher
from curstr.action.source.base import ActionSource as Base
from curstr.custom import ActionSourceOption


class ActionSource(Base):

    _DISPATCHER_CLASS = FileDispatcher

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')
        absolute_path = self._vim.call('fnamemodify', path, ':p')
        return self._dispatcher.dispatch_one(Directory, absolute_path)
