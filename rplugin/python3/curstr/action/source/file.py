
from curstr.action.group import ActionGroup, File, FileDispatcher
from curstr.custom import ActionSourceOption

from .base import ActionSource as Base


class ActionSource(Base):

    _DISPATCHER_CLASS = FileDispatcher

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')
        absolute_path = self._vim.call('fnamemodify', path, ':p')
        return self._dispatcher.dispatch((File, absolute_path))
