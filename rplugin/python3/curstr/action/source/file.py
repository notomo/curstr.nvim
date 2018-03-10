
from curstr.action.group import ActionGroup, File
from curstr.custom import ActionSourceOption

from .base import ActionSource as Base


class ActionSource(Base):

    def _create_action_group(self, option: ActionSourceOption) -> ActionGroup:
        path = self._vim.call('expand', '<cfile>')
        absolute_path = self._vim.call('fnamemodify', path, ':p')
        return self._dispatch((File, absolute_path))
